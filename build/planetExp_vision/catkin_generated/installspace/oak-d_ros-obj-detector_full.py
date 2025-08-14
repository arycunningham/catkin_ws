##!/usr/bin/env python3

""" IMPORTANT! Update the path of your virtual environment at line 1 before
running the script.

NOTE: Default cwd is set to $HOME/.ros, so two dots is the equivalent of checking the parent directory of cwd,
i.e., $HOME.

ROS USAGE
source $(rospack find planetexp_vision)/scripts/init_oak_d_vision <args>
"""

# Import required packages for backwards compability
from __future__ import print_function
# Print python interpreter
import sys
print("[INFO] Python interpreter path: " + sys.executable)

# Remove Python Path from ROS noetic to avoid conflicts with OpenVINO Optimized OpenCV.
# sys.path.remove('/opt/ros/noetic/lib/python3/dist-packages')
# Check invoked version of OpenCV package
import numpy as np
import cv2
print("[INFO] OpenCV module version: " + cv2.__version__)
# if(cv2.__version__[6:] != "openvino"):
#     sys.exit("[ERROR] Wrong OpenCV version. Aborting ...")

# Reinsert removed Python Path from ROS noetic
# sys.path.append('/opt/ros/noetic/lib/python3/dist-packages')

# Import required packages
# from preprocessing.camera import GenericCamera
# from conversors import coords_conversor
from sensor_msgs.msg import CompressedImage
from sensor_msgs.msg import NavSatFix
from geometry_msgs.msg import PoseStamped
from mavros_msgs.msg import HomePosition
from std_msgs.msg import Bool
from std_msgs.msg import Float64, Float32
from std_msgs.msg import String
import rospy
import rospkg
import argparse
import depthai as dai
import time
from math import asin


class vision_processor:
    def __init__(self, args):
        # ROS variables
        try:
            self.sensorWidth = rospy.get_param("/camera_model/sensor_width")
            self.sensorHeight = rospy.get_param("/camera_model/sensor_height")
            self.focalLength = rospy.get_param("/camera_model/focal_length")
            self.gimbalAngle = rospy.get_param("/camera_model/gimbal_angle")
            self.widthRes = rospy.get_param("/camera_model/width_res")
            self.heightRes = rospy.get_param("/camera_model/height_res")
            self.offsetX = rospy.get_param("/camera_model/offset_x")
            self.offsetY = rospy.get_param("/camera_model/offset_y")
            self.offsetZ = rospy.get_param("/camera_model/offset_z")

            self.cam_source = rospy.get_param("/camera_model/cam_input")
            self.pub_rate = rospy.get_param("/camera_model/pub_rate")
            self.nn_shape_w = rospy.get_param("/network_model/nn_shape_w")
            self.nn_shape_h = rospy.get_param("/network_model/nn_shape_h")
            self.model_name = rospy.get_param("/network_model/model_name")
            self.detect_threshold = rospy.get_param(
                "/network_model/detect_threshold") / 100

            # get an instance of RosPack with the default search paths
            rospack = rospkg.RosPack()
            # list all packages, equivalent to rospack list
            rospack.list()
            # get the file path for rospy_tutorials
            rospackage_path = rospack.get_path('planetexp_vision')

            self.nn_path = rospackage_path + "/models/oak-d_blobs/" + \
                self.model_name  # Need to be ajusted to file location
        except rospy.ROSException:
            rospy.logerr("Could not get parameters for visionSensor.")
            exit(0)

        # self.camera_model = GenericCamera(self.focalLength, self.sensorWidth, self.sensorHeight, self.widthRes, self.heightRes,
        #                                   self.offsetX, self.offsetY, self.offsetZ, self.gimbalAngle)
        # self.imgCoords = [0, 0]

        self.frame_publisher = rospy.Publisher(
            args["camera_ns"] + "/image_raw/compressed",
            CompressedImage,
            queue_size=1)

        self.net_publisher = rospy.Publisher(
            args["camera_ns"] + "/net_output/compressed",
            CompressedImage,
            queue_size=1)

        self.net_detectionRate = rospy.Publisher(
            args["camera_ns"] + "/net_output/detectionRate",
            Float32,
            queue_size=1)

        self.net_detection = rospy.Publisher(
            args["camera_ns"] + "/net_output/detection",
            Bool,
            queue_size=1)

        self.detectedTarget = False
        self.confidence = 0.0
        self.robotPose = PoseStamped()
        self.targetPose = PoseStamped()
        self.displayColor = (186, 82, 15)

        self.procFramePub = rospy.Publisher(
            args["node_ns"] + "/processed_image/compressed",
            CompressedImage,
            queue_size=1)
        self.targetFlagPub = rospy.Publisher(
            args["node_ns"] + "/target/is_detected",
            Bool,
            queue_size=1)
        self.targetCoordsPub = rospy.Publisher(
            args["node_ns"] + "/target/local_position",
            PoseStamped,
            queue_size=1)
        self.targetConfPub = rospy.Publisher(
            args["node_ns"] + "/target/det_confidence",
            Float64,
            queue_size=1)
        self.robotPoseSub = rospy.Subscriber(
            "/mavros/local_position/pose",
            PoseStamped,
            self.robotPoseCallback,
            queue_size=1)

        self.audioMsgPub = rospy.Publisher(
            "/scouter_ros/audio", String, queue_size=5, latch=True)
        self.isNodeReady = False

        # Global position variables
        self.target_global_pos = NavSatFix()
        self.geodetic_home = HomePosition()
        self.global_home_sub = rospy.Subscriber(
            "/mavros/home_position/home",
            HomePosition,
            self.global_home_callback,
            queue_size=1)
        # If running in 'mission' mode, publish 'global_pos_log' topic from here
        # instead of the solver ROS node.
        if (args["mission_mode"] == "true"):
            rospy.loginfo("Running module for 'mission' flight mode.")
            self.global_pos_pub = rospy.Publisher(
                "/scouter_ros/target/global_pos_log",
                NavSatFix,
                queue_size=5,
                latch=True)
        else:
            self.global_pos_pub = rospy.Publisher(
                args["node_ns"] + "/obj_global_pos",
                NavSatFix,
                queue_size=5,
                latch=True)

        publisher_rate = rospy.Rate(self.pub_rate)

        # OAK-D camera pipeline
        # Pipeline tells DepthAI what operations to perform when running - you define all of the resources used and flows here
        pipeline = dai.Pipeline()
        # Check version of Open Vino used for model export to blob.
        pipeline.setOpenVINOVersion(
            version=dai.OpenVINO.Version.VERSION_2021_2)

        # Define a neural network that will make predictions based on the source frames
        # Neural network definition and blob load
        detection_nn = pipeline.createNeuralNetwork()
        # Blob load into myriad RAM (up to 512Mb)
        detection_nn.setBlobPath(self.nn_path)

        # Size of image for for inference engine.
        detection_nn.setNumPoolFrames(2)
        # Sets queue behavior when full (maxSize)
        detection_nn.input.setBlocking(False)
        # How many threads should the node use to run the network.
        detection_nn.setNumInferenceThreads(2)

        cam = None
        # Define a source - color camera
        if self.cam_source == 'rgb':
            cam = pipeline.createColorCamera()
            cam.setImageOrientation(dai.CameraImageOrientation.ROTATE_180_DEG)
            cam.setPreviewSize(self.nn_shape_w, self.nn_shape_h)
            cam.setInterleaved(False)
            cam.preview.link(detection_nn.input)
        elif self.cam_source == 'left':
            cam = pipeline.createMonoCamera()
            cam.setBoardSocket(dai.CameraBoardSocket.LEFT)
        elif self.cam_source == 'right':
            cam = pipeline.createMonoCamera()
            cam.setBoardSocket(dai.CameraBoardSocket.RIGHT)

        # if self.cam_source != 'rgb':
        #     manip = pipeline.createImageManip()
        #     manip.setResize(self.nn_shape_w, self.nn_shape_h)
        #     manip.setKeepAspectRatio(False)
        #     manip.setFrameType(dai.RawImgFrame.Type.BGR888p)
        #     cam.out.link(manip.inputImage)
        #     manip.out.link(detection_nn.input)

        # Change camera output from BGR to RGB
        cam.setBoardSocket(dai.CameraBoardSocket.RGB)
        cam.setColorOrder(dai.ColorCameraProperties.ColorOrder.RGB)

        cam.setFps(30)
        # Create outputs from camera / input for network
        xout_rgb = pipeline.createXLinkOut()
        xout_rgb.setStreamName("nn_input")
        # Input message with data to be infered upon (Default queue is blocking with size 5)
        xout_rgb.input.setBlocking(False)

        # Passthrough message on which the inference was performed.
        detection_nn.passthrough.link(xout_rgb.input)

        # Create outputs from network
        xout_nn = pipeline.createXLinkOut()
        xout_nn.setStreamName("nn")
        xout_nn.input.setBlocking(False)

        # Outputs ImgDetections message that carries parsed detection results. Connected with Xout input
        detection_nn.out.link(xout_nn.input)

        # First, we want the Color camera as the output
        #cam_rgb = pipeline.createColorCamera()
        #cam_rgb.setPreviewSize(width_res, height_res)
        # cam_rgb.setInterleaved(False)

        # XLinkOut is a "way out" from the device. Any data you want to transfer to host need to be send via XLink
        #xout_rgb = pipeline.createXLinkOut()
        # For the rgb camera output, we want the XLink stream to be named "rgb"
        # xout_rgb.setStreamName("rgb")
        # Linking camera preview to XLink input, so that the frames will be sent to host
        # cam_rgb.preview.link(xout_rgb.input)

        # Pipeline is now finished, and we need to find an available device to run our pipeline
        # we are using context manager here that will dispose the device after we stop using it
        with dai.Device(pipeline) as device:
            # And start. From this point, the Device will be in "running" mode and will start sending data via XLink
            device.startPipeline()      # Starts the execution of the devices pipeline

            # To consume the device results, we get two output queues from the device, with stream names we assigned earlier
            q_nn_input = device.getOutputQueue(
                name="nn_input", maxSize=1, blocking=False)
            q_nn = device.getOutputQueue(name="nn", maxSize=1, blocking=False)

            # FPS measurment variables
            start_time = time.time()
            counter = 0
            fps = 0

            # Used to print the output layer details once
            layer_info_printed = False

            # Here, some of the default values are defined. Frame will be an image from "rgb" stream.
            frame = None

            # Flag to update pixel properties once.
            is_res_updated = False

            # --------------------------------- Main host-side application loop --------------------------------------------
            while not rospy.is_shutdown():
                # we try to fetch the data from rgb queues. tryGet will return either the data packet or None if there isn't any
                #in_rgb = q_rgb.tryGet()
                in_nn_input = q_nn_input.tryGet()
                in_nn = q_nn.tryGet()

                if in_nn_input is not None:
                    # if the data from the rgb camera is available, transform the 1D data into a HxWxC frame
                    shape = (3, in_nn_input.getHeight(),
                             in_nn_input.getWidth())

                    # Also, the array is transformed from CHW form into HWC
                    frame = in_nn_input.getData().reshape(shape).transpose(1, 2, 0).astype(np.uint8)
                    frame = np.ascontiguousarray(frame)

                detection_mask = np.zeros((self.nn_shape_w, self.nn_shape_h))
                # The raw image is published if not None
                if frame is not None:
                    # Convert image from RGB to BGR OpenCV
                    frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)
                    self.publish_raw_frame(self.frame_publisher, frame)

                    # Detection status clean
                    status = ""
                    self.detectedTarget = False
                    self.confidence = 0.0
                    # Check network output
                    if in_nn is not None:
                        # --------------------------------- Here we have networks results -----------------------
                        layers = in_nn.getAllLayers()        # returns All layers and their information

                        # Print layer details only once
                        if not layer_info_printed:
                            for layer_nr, layer in enumerate(layers):
                                rospy.loginfo(f"Layer {layer_nr}")
                                rospy.loginfo(f"Name: {layer.name}")
                                rospy.loginfo(f"Order: {layer.order}")
                                rospy.loginfo(f"dataType: {layer.dataType}")
                                dims = layer.dims
                                rospy.loginfo(f"dims: {dims}")
                        layer_info_printed = True

                        lay = layers[-1]
                        dims = lay.dims#[::-1]

                        if 'road' in self.nn_path or 'Unet' in self.nn_path or 'DeepLab' in self.nn_path or 'res18_skip' in self.nn_path:
                            # float value, Class probability
                            layer1 = in_nn.getLayerFp16(layers[0].name)
                            lay1 = np.asarray(layer1, dtype=np.double).reshape(
                                dims)  # Shaped to closer int32
                            # Normalice output between 0-1
                            lay1norm = ((lay1-lay1.min()) /
                                        (lay1.max()-lay1.min()))*1
                            framemax = np.argmax(lay1norm[0], axis=0)

                        else:  # People detector
                            layer1 = in_nn.getLayerInt32(layers[0].name)
                            framemax = np.asarray(layer1, dtype=np.int32).reshape(
                                dims)  # Shaped to closer int32

                        # Colorise and extract frame from from (x,x,h,w) to (h,w)
                        detection_mask = self.decode_deeplabv3p(
                            framemax.astype(int), dims[2], dims[3])
                        # detection_mask = self.show_deeplabv3p(detection_mask, frame)   # Blend imput image with output network.

                        # Publish network results (image)
                        self.publish_raw_frame(
                            self.net_publisher, detection_mask)

                        # Update resolution camera property based on processed image
                        # if is_res_updated is False:
                        #     self.camera_model.set_res_x(
                        #         detection_mask.shape[1])
                        #     self.camera_model.set_res_y(
                        #         detection_mask.shape[0])
                        #     rospy.loginfo("Updated Camera Model Res X: {}".format(
                        #         detection_mask.shape[1]))
                        #     rospy.loginfo("Updated Camera Model Res X: {}".format(
                        #         detection_mask.shape[0]))
                        #     # Update flag
                        #     is_res_updated = True

                        # Extraction of biggest blob patch
                        image_binary = np.zeros(
                            (detection_mask.shape[0], detection_mask.shape[1], 1), np.uint8)

                        # Do threshold in chanel 2 Red (BGR)
                        ret, image_thresh = cv2.threshold(
                            detection_mask[:, :, 2], 128, 255, cv2.THRESH_BINARY)

                        # Extract contours
                        contours = cv2.findContours(image_thresh, 1, 1)[0]

                        # Collect maximum contour
                        if len(contours) > 0:
                            max_contour = max(contours, key=cv2.contourArea)
                            cv2.drawContours(image_binary, [max_contour],
                                             -1, (255, 255, 255), -1)

                            # (x,y) top-left coordinate of the rectangle and (w,h) be its width and height
                            x, y, w, h = cv2.boundingRect(max_contour)
                            self.confidence = np.count_nonzero(
                                image_binary)/float(image_binary.shape[0] * image_binary.shape[1])

                            # Conversion of coordinates
                            startX = x
                            startY = y
                            endX = x+w
                            endY = y+h

                            # Compute center of image
                            cX = (endX + startX) / 2
                            cY = (endY + startY) / 2

                            # Obtain the bottom extreme point of the contour if gimbalAngle > 10 (to get an approximate GSD)
                            if(self.gimbalAngle > 10):
                                self.imgCoords = [cX, endY]
                            else:
                                self.imgCoords = [cX, cY]

                            # Bounding box drawing
                            # draw the prediction on the frame
                            # cv2.rectangle(detection_mask, (startX, startY), (endX, endY),
                            #             self.displayColor, 2)

                            y = startY - 14 if startY - 14 > 14 else startY + 14

                            label = "{:.2f}%".format(self.confidence * 100)
                            # cv2.putText(detection_mask, label, (startX + 5, y),
                            #             cv2.FONT_HERSHEY_SIMPLEX, 0.5, self.displayColor, 2)
                            status = "Crack detected!"
                            # detection_mask = self.drawDetectionResults(
                            # detection_mask, status, cX, cY)
                            if (self.confidence > self.detect_threshold):
                                self.detectedTarget = True

                            # Estimate local object position
                            #obj_local_pos = self.targetPoseEstimation()
                            # print("local_coords: {}. Global home: {}".format(obj_local_pos, self.geodetic_home.geo))
                            # Convert local to global position coordinates
                            # geodetic_coords = coords_conversor.local_to_global(
                            #     obj_local_pos,
                            #     (self.geodetic_home.geo.latitude,
                            #         self.geodetic_home.geo.longitude,
                            #         self.geodetic_home.geo.altitude))
                            # # Publish global coordinates
                            # self.target_global_pos.latitude = geodetic_coords[0]
                            # self.target_global_pos.longitude = geodetic_coords[1]
                            #self.target_global_pos.altitude = self.geodetic_home.geo.altitude
                           # self.target_global_pos.header.stamp = rospy.Time.now()
                            #self.global_pos_pub.publish(self.target_global_pos)

                            # Compute detection status and percentage from pixel count operation
                            #sought = [0,0,255]
                            # Find all pixels where the 3 RGB values match "sought", and count them
                            #detection_value = 300.0*np.count_nonzero(np.all(detection_mask==sought,axis=2))/detection_mask.size

                            # Publish network results (% detection and detection theshold)
                            self.publish_detection_rate(
                                self.net_detectionRate, self.confidence)
                            self.publish_detection(
                                self.net_detection, self.detectedTarget)

                            # # Add caption to output frame
                            # cv2.putText(detection_mask,
                            #             "NN fps: {:.2f}".format(fps),
                            #             (2, detection_mask.shape[0] - 4),
                            #             cv2.FONT_HERSHEY_TRIPLEX,
                            #             0.4, (255, 0, 0))

                        # detection_mask = self.show_deeplabv3p(detection_mask, frame)   # Blend imput image with output network.

                # # FPS computation.
                # counter += 1
                # if (time.time() - start_time) > 1:
                #     # Number of counts / time pass in seconds
                #     fps = counter / (time.time() - start_time)
                #     counter = 0                 # Counter restart
                #     start_time = time.time()    # Time restart

                # if self.detectedTarget:
                #     target_pos = self.targetPoseEstimation()
                #     self.targetPose.pose.position.x = target_pos[0]
                #     self.targetPose.pose.position.y = target_pos[1]
                #     self.targetPose.pose.position.z = target_pos[2]

                rospy.loginfo_once("Serialising outputs ...")
                # Just serialise output frame if there is at least a node subscribed to the topic
                if (self.procFramePub.get_num_connections() > 0):
                    msg = CompressedImage()
                    msg.header.stamp = rospy.Time.now()
                    msg.format = "jpeg"
                    msg.data = np.array(cv2.imencode(
                        '.jpg', detection_mask)[1]).tostring()
                    # Publish new image
                    self.procFramePub.publish(msg)

                # if in_nn is not None:
                #     self.targetFlagPub.publish(self.detectedTarget)
                #     self.targetConfPub.publish(self.confidence)
                #     self.targetCoordsPub.publish(self.targetPose)

                rospy.loginfo_once("Vision pipeline is successful!")
                rospy.loginfo_once("Iterating pipeline indefinitely.")

                if (self.isNodeReady == False):
                    rospy.loginfo_once("*********************")
                    rospy.loginfo_once("* Myriad Node Ready *")
                    rospy.loginfo_once("*********************")
                    self.playAudioMessage("cv-module")
                    self.isNodeReady = True

                # --------------------------------- end of image processing -----------------------
                try:
                    publisher_rate.sleep()
                except KeyboardInterrupt:
                    rospy.loginfo("Shutting down.")

    def robotPoseCallback(self, data):
        self.robotPose = data

    def global_home_callback(self, data):
        self.geodetic_home = data

    def drawDetectionResults(self, _frame, status, cX, cY):
        # Compute extra margin for bounding box
        marginX = 5
        marginY = 5

        # Get line points with added margin
        (startLineX, endLineX) = (int(cX - marginX), int(cX + marginX))
        (startLineY, endLineY) = (int(cY - marginY), int(cY + marginY))

        # draw the status text on the frame
        # cv2.putText(_frame,
        #             status,
        #             (5, 25 * int(_frame.shape[1] / float(320))),
        #             cv2.FONT_HERSHEY_SIMPLEX,
        #             0.75 * (_frame.shape[1] / float(320)),
        #             self.displayColor,
        #             2 * int(_frame.shape[1] / float(320)))

        coords = self.targetPoseEstimation()
        # cv2.putText(_frame, "Coords: [%.2f, %.2f, %.2f]" % (coords[0], coords[1], coords[2]),
        #             (5, 230 * int(_frame.shape[1] / float(320))),
        #             cv2.FONT_HERSHEY_SIMPLEX,
        #             0.35 * int(_frame.shape[1] / float(320)),
        #             self.displayColor,
        #             2 * int(_frame.shape[1] / float(320)))
        return _frame

    # def targetPoseEstimation(self):
    #     # Calculate the distance between the target and the robot
    #     targetDistance = self.camera_model.calculateobjectdistance(
    #         self.robotPose.pose.position.z, self.imgCoords[0], self.imgCoords[1])
    #     # Calculate target coordinates based on the UAV -> target distance and UAV pose
    #     target_position = self.camera_model.calculateObjCoords(
    #         targetDistance,
    #         float(self.quaternionZToTheta(
    #             self.robotPose.pose.orientation.z)),
    #         [float(self.robotPose.pose.position.y),
    #          float(self.robotPose.pose.position.x)])
    #     return target_position

    def publish_raw_frame(self, publisher, camera_frame):
        rospy.loginfo_once("Serialising outputs ...")
        try:
            # Just serialise output frame if there is at least a node subscribed to the topic
            if (publisher.get_num_connections() > 0):
                msg = CompressedImage()
                msg.header.stamp = rospy.Time.now()
                msg.format = "jpeg"
                msg.data = np.array(cv2.imencode(
                    '.jpg', camera_frame)[1]).tostring()
                # Publish new image
                publisher.publish(msg)

            rospy.loginfo_once("Frame publishing pipeline is successful!")
            rospy.loginfo_once("Iterating pipeline indefinitely.")

            rospy.loginfo_once(
                "FPS:" + str(rospy.get_param("/camera_model/pub_rate")))
            rospy.loginfo_once("*************************")
            rospy.loginfo_once("* Frame Pub. Node Ready *")
            rospy.loginfo_once("*************************")

        except rospy.ROSException as e:
            rospy.logerr(e)
            exit(0)

    def publish_detection_rate(self, publisher, detectionVal):
        rospy.loginfo_once("Serialising outputs ...")
        try:
            # Just serialise output frame if there is at least a node subscribed to the topic
            if (publisher.get_num_connections() > 0):
                msg = Float32()
                #msg.name = str(rospy.Time.now())
                msg.data = detectionVal
                #msg.data = 10.0
                # Publish new data
                publisher.publish(msg)
                rospy.loginfo_once("************DR*************")

        except rospy.ROSException as e:
            rospy.logerr(e)
            exit(0)

    def publish_detection(self, publisher, detection):
        rospy.loginfo_once("Serialising outputs ...")
        try:
            # Just serialise output frame if there is at least a node subscribed to the topic
            if (publisher.get_num_connections() > 0):
                msg = Bool()
                msg.data = detection
                # Publish new data
                publisher.publish(msg)
                rospy.loginfo_once("************DT*************")

        except rospy.ROSException as e:
            rospy.logerr(e)
            exit(0)

    def decode_deeplabv3p(self, output_tensor, size_h, size_w):
        class_colors = [[0, 0, 0], [0, 0, 255], [
            0, 0, 255], [255, 0, 0], [255, 255, 0]]
        class_colors = np.asarray(class_colors, dtype=np.uint8)

        # Cut initial dimentions from (1,1,256,256) to (256,256)
        output = output_tensor.reshape(size_h, size_w)
        # Change the pixels in 1 to color in class_colors[1]
        output_colors = np.take(class_colors, output, axis=0)

        return output_colors

    def show_deeplabv3p(self, output_colors, frame):
        #print("Frame to add color: ")
        # print(frame.shape)
        if (output_colors.shape != frame.shape):
            dim = (frame.shape[1], frame.shape[0])  # (width, height)
            output_colors = cv2.resize(
                output_colors, dim, interpolation=cv2.INTER_AREA)
        # print(framealone.shape)
        return cv2.addWeighted(frame, 1, output_colors, 0.9, 0)

    def quaternionZToTheta(self, quatZ):
        return 2 * asin(quatZ)

    # def quaternionToEulerYaw(self, quaternion):
    #     orientation_list = [quaternion.x, quaternion.y, quaternion.z, quaternion.w]
    #     (_, _, yaw) = euler_from_quaternion(orientation_list)
    #     return yaw

    def playAudioMessage(self, msg):
        rospy.logdebug("Publishing to play: %s", msg)
        self.audioMsgPub.publish(String(msg))


def arg_parser(raw_args=None):
    # construct the argument parse and parse the arguments.
    ap = argparse.ArgumentParser()
    ap.add_argument("-ns", "--camera_ns", required=False, default="",
                    help="Name of the ROS camera namespace.")
    ap.add_argument("-t", "--camera_topic", required=False, default="/camera/image_raw",
                    help="Name of the ROS camera topic to process.")
    ap.add_argument("-nns", "--node_ns", required=False, default="/scouter_vision",
                    help="Namespace for ROS node.")
    ap.add_argument("-mm", "--mission_mode", required=False, action='store_const',
                    default="false", const="true",
                    help="Run the module for mission flight mode (will publish global coordinates for any detection).")
    if raw_args is None:
        args = vars(ap.parse_args(rospy.myargv()[1:]))
    else:
        args = vars(ap.parse_args(raw_args))

    return args


def main(args):
    rospy.init_node('oak_d_target_detection', anonymous=True)
    try:
        vision_processor(args)
        rospy.spin()
    except KeyboardInterrupt:
        rospy.loginfo("Shutting down")


if __name__ == '__main__':
    try:
        args = arg_parser()
        main(args)
    except rospy.ROSInterruptException as e:
        rospy.logerr(e)
