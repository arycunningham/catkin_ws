#!/usr/bin/env python3

# Print python interpreter
import sys
print("[INFO] Python interpreter path: " + sys.executable)
import numpy as np
import cv2
print("[INFO] OpenCV module version: " + cv2.__version__)

# Import required packages
from sensor_msgs.msg import CompressedImage
from sensor_msgs.msg import NavSatFix
from geometry_msgs.msg import PoseStamped
from mavros_msgs.msg import HomePosition
from std_msgs.msg import Bool
from std_msgs.msg import Float32, Float64
from std_msgs.msg import String
import rospy
import rospkg
import time
import depthai as dai
import argparse
from math import asin
import sys


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

        self.cv_image = None
        self.cv_image_stamp = None
        self.detected_target = False
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
                args["node_ns"] + "/target/global_pos_log",
                NavSatFix,
                queue_size=5,
                latch=True)
        else:
            self.global_pos_pub = rospy.Publisher(
                args["node_ns"] + "/obj_global_pos",
                NavSatFix,
                queue_size=5,
                latch=True)

        camera_ns_topic = args["camera_ns"] + args["camera_topic"]
        self.cameraFrameSub = rospy.Subscriber(
            name=camera_ns_topic,
            data_class=CompressedImage,
            callback=self.cameraFrameCallback,
            callback_args=None,
            queue_size=1,
            buff_size=16777216)
        self.isNodeReady = False

        # Julian specific publishers
        self.frame_publisher = rospy.Publisher(
            args["node_ns"] + "/image_raw/compressed",
            CompressedImage,
            queue_size=1)
        self.net_publisher = rospy.Publisher(
            args["node_ns"] + "/net_output/compressed",
            CompressedImage,
            queue_size=1)
        self.net_detectionRate = rospy.Publisher(
            args["node_ns"] + "/net_output/detectionRate",
            Float32,
            queue_size=1)
        self.net_detection = rospy.Publisher(
            args["node_ns"] + "/net_output/detection",
            Bool,
            queue_size=1)

        # Check whether the ROS topic to subscribe exists
        while (rospy.wait_for_message(camera_ns_topic, CompressedImage) is None):
            rospy.logwarn_throttle(
                period=1, msg="{} hasn't been advertised yet ...".format(camera_ns_topic))
        rospy.loginfo(
            "Vision node subscribed to topic: {}.".format(camera_ns_topic))

        # OAK-D camera pipeline
        pipeline = self.create_oakd_pipeline()

        # FPS measurement variables
        self.start_time = time.time()
        self.counter = 0
        self.fps = 0

        # Used to print the output layer details once
        self.layer_info_printed = False
        # Flag to update pixel properties once.
        self.is_res_updated = False

        # Pipeline is now finished, and we need to find an available device to run our pipeline
        # we are using context manager here that will dispose the device after we stop using it
        with dai.Device(pipeline) as device:
            q_in = device.getInputQueue(name="inFrame")
            # getting an output queue to get nn data from video frames
            q_nn = device.getOutputQueue(name="nn", maxSize=4, blocking=False)

            # ----------- Main host-side application loop ------------------
            while not rospy.is_shutdown():
                rospy.loginfo_once(
                    "Performing inference for the first time ...")
                proc_frame, self.detected_target, self.confidence = self.perform_inference(
                    q_in, q_nn)

                rospy.loginfo_once("Serialising outputs ...")
                try:
                    # Just serialise output frame if there is at least a node subscribed to the topic
                    if (self.procFramePub.get_num_connections() > 0):
                        msg = CompressedImage()
                        msg.header.stamp = self.cv_image_stamp  # Here we fast-forward src_img stamp
                        msg.format = "jpeg"
                        msg.data = np.array(cv2.imencode(
                            '.jpg', proc_frame)[1]).tostring()
                        # Publish new image
                        self.procFramePub.publish(msg)

                    self.targetFlagPub.publish(self.detected_target)
                    self.targetConfPub.publish(self.confidence)
                    self.targetCoordsPub.publish(self.targetPose)

                    rospy.loginfo_once("OAK-D pipeline is successful!")
                    rospy.loginfo_once("Iterating pipeline indefinitely.")
                    if (self.isNodeReady == False):
                        rospy.loginfo_once("***********************")
                        rospy.loginfo_once("* Myriad Module Ready *")
                        rospy.loginfo_once("***********************")
                        self.isNodeReady = True
                except:
                    rospy.logerror("Error serialising processed frame.")

    def cameraFrameCallback(self, data):
        np_arr = np.fromstring(data.data, np.uint8)
        self.cv_image = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
        self.cv_image_stamp = data.header.stamp

        if (self.cv_image is None):
            rospy.logerr("Camera frame is empty.")

    def robotPoseCallback(self, data):
        self.robotPose = data

    def global_home_callback(self, data):
        self.geodetic_home = data

    def perform_inference(self, q_in, q_nn):
        """[summary]

        Args:
            q_in ([type]): [description]
            q_nn ([type]): [description]

        Returns:
            [type]: [description]
        """
        status = ""
        confidence = 0.0
        detectedTarget = False

        if self.cv_image is not None:
            img = dai.ImgFrame()
            img.setData(self.preprocess((self.nn_shape_h, self.nn_shape_w)))
            img.setWidth(self.nn_shape_w)
            img.setHeight(self.nn_shape_h)
            q_in.send(img)

            detection_mask = np.zeros((self.nn_shape_w, self.nn_shape_h))

            # we try to fetch the data from rgb queues. tryGet will return either the data packet or None if there isn't any
            out_nn = q_nn.tryGet()
            # Check network output
            if out_nn is not None:
                # ----------- Here we have networks results -----------------
                layers = out_nn.getAllLayers()  # returns All layers and their information

                # Print layer details only once
                if not self.layer_info_printed:
                    for layer_nr, layer in enumerate(layers):
                        rospy.loginfo(f"Layer {layer_nr}")
                        rospy.loginfo(f"Name: {layer.name}")
                        rospy.loginfo(f"Order: {layer.order}")
                        rospy.loginfo(f"dataType: {layer.dataType}")
                        dims = layer.dims
                        #dims = layer.dims[::-1]  # reverse dimensions
                        rospy.loginfo(f"dims: {dims}")
                    self.layer_info_printed = True

                lay = layers[-1]
                dims = lay.dims#[::-1]

                # float value, Class probability
                layer1 = out_nn.getLayerFp16(layers[0].name)
                lay1 = np.asarray(layer1, dtype=np.double).reshape(
                    dims)  # Shaped to closer int32
                # Normalice output between 0-1
                
                lay1norm = ((lay1-lay1.min())/(lay1.max()-lay1.min()))*1
                framemax = np.argmax(lay1norm[0], axis=0)

                # Colorise and extract frame from from (x,x,h,w) to (h,w)
                detection_mask = self.decode_deeplabv3p(
                    framemax.astype(int), dims[2], dims[3])

                # Publish network results (image)
                self.publish_raw_frame(self.procFramePub, detection_mask)

        return detection_mask, detectedTarget, confidence

    def create_oakd_pipeline(self):
        # Pipeline tells DepthAI what operations to perform when running
        # You define all of the resources used and flows here
        pipeline = dai.Pipeline()
        # Check version of Open Vino used for model export to blob.
        pipeline.setOpenVINOVersion(
            version=dai.OpenVINO.Version.VERSION_2021_4)

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

        # Creating the links for the network
        # Link 1: From Host to Device - before the network
        xinFrame = pipeline.createXLinkIn()
        xinFrame.setStreamName("inFrame")

        # Link 2: From Device to Host - after the network
        nn_out = pipeline.createXLinkOut()
        nn_out.setStreamName("nn")

        # Linking both sides of the network to a stream
        # xin is the input from the host
        xinFrame.out.link(detection_nn.input)
        # xout is the output to the host
        detection_nn.out.link(nn_out.input)
        return pipeline

    def preprocess(self, target_shape):
        """
            Preprocessing steps - as necessary
                1. resize
                2. transpose
                3. flattening
        """
        if self.cv_image is not None:
            # Change image to RGB as required by blob file
            temp = cv2.cvtColor(self.cv_image, cv2.COLOR_BGR2RGB)
            temp = cv2.resize(temp, (target_shape[1], target_shape[0]))
            # This is a hack to swap rows and columns :(
            temp = cv2.flip(cv2.rotate(
                temp, cv2.ROTATE_90_CLOCKWISE), 1)
            # Transpose
            temp = temp.T
            # Flatten
            preprocessed = temp.flatten()
            return preprocessed
        else:
            return self.cv_image

    def decode_deeplabv3p(self, output_tensor, size_h, size_w):
        class_colors = [[0, 0, 0], [0, 0, 255], [
            0, 0, 255], [255, 0, 0], [255, 255, 0]]
        class_colors = np.asarray(class_colors, dtype=np.uint8)
        #print(output_tensor)
        # Cut initial dimentions from (1,1,256,256) to (256,256)
        output = output_tensor.reshape(size_h, size_w)
        # Change the pixels in 1 to color in class_colors[1]
        output_colors = np.take(class_colors, output, axis=0)

        return output_colors

    def show_deeplabv3p(self, output_colors, frame):
        if (output_colors.shape != frame.shape):
            dim = (frame.shape[1], frame.shape[0])  # (width, height)
            output_colors = cv2.resize(
                output_colors, dim, interpolation=cv2.INTER_AREA)
        # print(framealone.shape)
        return cv2.addWeighted(frame, 1, output_colors, 0.9, 0)

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
    rospy.init_node('oakd_target_detection', anonymous=True)
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
