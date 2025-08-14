#!/usr/bin/env python3

"""
ROS USAGE
source $(command rospack find planetexp_vision)/oak_d/init_oak_d_streamer <args>
"""

from std_msgs.msg import Float32, Bool
import time
import depthai as dai
import argparse
import rospy
from sensor_msgs.msg import CompressedImage
import cv2
import numpy as np
# Print python interpreter
import sys
print("[INFO] Python interpreter path: " + sys.executable)
# Check invoked version of OpenCV package
print("[INFO] OpenCV module version: " + cv2.__version__)

def decode_deeplabv3p(output_tensor, size_h, size_w):
    class_colors = [[0, 0, 0], [0, 0, 255], [
        0, 0, 255], [255, 0, 0], [255, 255, 0]]
    class_colors = np.asarray(class_colors, dtype=np.uint8)
    if (output_tensor.shape[1] > 1):
        output = output_tensor.reshape(output_tensor.shape[1], size_h, size_w)
        output_colors = np.take(class_colors, output[0], axis=0)
        classNum = 2  # used to give the color to the map
        for single_output in output[1:]:
            output_colors += np.take(class_colors, single_output, axis=0)
            classNum += 1
    else:
        output = output_tensor.reshape(size_h, size_w)
        output_colors = np.take(class_colors, output, axis=0)
    return output_colors


def show_deeplabv3p(output_colors, frame):
    return cv2.addWeighted(frame, 1, output_colors, 0.5, 0)


def frame_publisher_ROS(args):
    # ROS variables
    try:
        width_res = rospy.get_param("/camera_model/width_res")
        height_res = rospy.get_param("/camera_model/height_res")
        cam_source = rospy.get_param("/camera_model/cam_input")
        pub_rate = rospy.get_param("/camera_model/pub_rate")

        nn_shape_w = rospy.get_param("/network_model/nn_shape_w")
        nn_shape_h = rospy.get_param("/network_model/nn_shape_h")
        model_name = rospy.get_param("/network_model/model_name")
        detect_threshold = rospy.get_param("/network_model/detect_threshold")
        nn_path = "/home/<username>/rosEagles/src/planetexp_vision/models/oak-d_blobs/" + \
            model_name  # Need to be ajusted to file location
    except rospy.ROSException:
        rospy.logerr("Could not get parameters for visionSensor.")
        exit(0)

    frame_publisher = rospy.Publisher(args["node_ns"] + "/image_raw/compressed",
                                      CompressedImage, queue_size=1)

    net_publisher = rospy.Publisher(args["node_ns"] + "/net_output/compressed",
                                    CompressedImage, queue_size=1)

    net_detectionRate = rospy.Publisher(args["node_ns"] + "/net_output/detectionRate",
                                        Float32, queue_size=1)

    net_detection = rospy.Publisher(args["node_ns"] + "/net_output/detection",
                                    Bool, queue_size=1)

    publisher_rate = rospy.Rate(pub_rate)

    # OAK-D variables

    # Pipeline tells DepthAI what operations to perform when running - you define all of the resources used and flows here
    pipeline = dai.Pipeline()

    pipeline.setOpenVINOVersion(version=dai.OpenVINO.Version.VERSION_2021_2)

    # Define a neural network that will make predictions based on the source frames
    detection_nn = pipeline.createNeuralNetwork()
    detection_nn.setBlobPath(nn_path)

    detection_nn.setNumPoolFrames(2)
    detection_nn.input.setBlocking(False)
    detection_nn.setNumInferenceThreads(2)

    cam = None
    # Define a source - color camera
    if cam_source == 'rgb':
        cam = pipeline.createColorCamera()
        cam.setPreviewSize(nn_shape_w, nn_shape_h)
        cam.setInterleaved(False)
        cam.preview.link(detection_nn.input)
    elif cam_source == 'left':
        cam = pipeline.createMonoCamera()
        cam.setBoardSocket(dai.CameraBoardSocket.LEFT)
    elif cam_source == 'right':
        cam = pipeline.createMonoCamera()
        cam.setBoardSocket(dai.CameraBoardSocket.RIGHT)

    """ if cam_source != 'rgb':
        manip = pipeline.createImageManip()
        manip.setResize(nn_shape_w,nn_shape_h)
        manip.setKeepAspectRatio(False)
        manip.setFrameType(dai.RawImgFrame.Type.BGR888p)
        cam.out.link(manip.inputImage)
        manip.out.link(detection_nn.input) """

    cam.setFps(30)
    # Create outputs
    xout_rgb = pipeline.createXLinkOut()
    xout_rgb.setStreamName("nn_input")
    xout_rgb.input.setBlocking(False)

    detection_nn.passthrough.link(xout_rgb.input)

    xout_nn = pipeline.createXLinkOut()
    xout_nn.setStreamName("nn")
    xout_nn.input.setBlocking(False)

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
        device.startPipeline()

        # To consume the device results, we get two output queues from the device, with stream names we assigned earlier
        q_nn_input = device.getOutputQueue(
            name="nn_input", maxSize=1, blocking=False)
        q_nn = device.getOutputQueue(name="nn", maxSize=1, blocking=False)

        #q_rgb = device.getOutputQueue("rgb")
        start_time = time.time()
        counter = 0
        fps = 0
        layer_info_printed = False

        # Here, some of the default values are defined. Frame will be an image from "rgb" stream.
        frame = None

        # Main host-side application loop
        while not rospy.is_shutdown():
            # we try to fetch the data from rgb queues. tryGet will return either the data packet or None if there isn't any
            #in_rgb = q_rgb.tryGet()
            in_nn_input = q_nn_input.tryGet()
            in_nn = q_nn.tryGet()

            if in_nn_input is not None:
                # if the data from the rgb camera is available, transform the 1D data into a HxWxC frame
                shape = (3, in_nn_input.getHeight(), in_nn_input.getWidth())
                # Also, the array is transformed from CHW form into HWC
                frame = in_nn_input.getData().reshape(shape).transpose(1, 2, 0).astype(np.uint8)
                frame = np.ascontiguousarray(frame)

            # The raw image is published if not None
            if frame is not None:
                publish_raw_frame(frame_publisher, frame)

            # Check network output
            if in_nn is not None:
                # print("NN received")
                layers = in_nn.getAllLayers()

                for layer_nr, layer in enumerate(layers):
                    rospy.loginfo_once(f"Layer {layer_nr}")
                    rospy.loginfo_once(f"Name: {layer.name}")
                    rospy.loginfo_once(f"Order: {layer.order}")
                    rospy.loginfo_once(f"dataType: {layer.dataType}")
                    dims = layer.dims[::-1]  # reverse dimensions
                    rospy.loginfo_once(f"dims: {dims}")

                if 'road' in nn_path or 'Unet' in nn_path or 'DeepLab' in nn_path:
                    # float value, Class probability
                    layer1 = in_nn.getLayerFp16(layers[0].name)
                else:
                    layer1 = in_nn.getLayerInt32(layers[0].name)

                # reshape to numpy array
                dims = layer.dims[::-1]
                lay1 = np.asarray(layer1, dtype=np.double).reshape(
                    dims)  # Shaped to closer int32
                # lay1 = (lay1/(lay1.max()-lay1.min()))+0.7 # Normalice output between 0-1

                output_colors = decode_deeplabv3p(
                    lay1.astype(int), dims[2], dims[3])

                # cv2.countNonZero(det_frame)
                sought = [0, 0, 255]
                # Find all pixels where the 3 RGB values match "sought", and count them
                detection_value = 300.0 * \
                    np.count_nonzero(
                        np.all(output_colors == sought, axis=2))/output_colors.size
                publish_detection_rate(net_detectionRate, detection_value)
                publish_detection(
                    net_detection, detection_value > detect_threshold)

                if frame is not None:
                    #frameNN = show_deeplabv3p(output_colors, frame)
                    frameNN = output_colors
                    #publish_detection_rate(net_detectionRate, frameNN)
                    cv2.putText(frameNN, "NN fps: {:.2f}".format(
                        fps), (2, frameNN.shape[0] - 4), cv2.FONT_HERSHEY_TRIPLEX, 0.4, (255, 0, 0))
                    publish_raw_frame(net_publisher, frameNN)

            counter += 1
            if (time.time() - start_time) > 1:
                fps = counter / (time.time() - start_time)
                counter = 0
                start_time = time.time()

            try:
                publisher_rate.sleep()
            except KeyboardInterrupt:
                rospy.loginfo("Shutting down.")


def publish_raw_frame(publisher, camera_frame):
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


def publish_detection_rate(publisher, detectionVal):
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


def publish_detection(publisher, detection):
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
    ap.add_argument("-nns", "--node_ns", required=False, default="/oak_d",
                    help="Namespace for ROS node.")
    if raw_args is None:
        args = vars(ap.parse_args(rospy.myargv()[1:]))
    else:
        args = vars(ap.parse_args(raw_args))

    return args


def main(args):
    rospy.init_node('oak_d_frame_publisher', anonymous=True)
    frame_publisher_ROS(args)


if __name__ == '__main__':
    try:
        args = arg_parser()
        main(args)
    except rospy.ROSInterruptException as e:
        rospy.logerr(e)
