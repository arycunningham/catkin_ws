#!../.virtualenvs/intelncs/bin/python

""" IMPORTANT! Update the path of your virtual environment at line 1 before
running the script.

NOTE: Default cwd is set to $HOME/.ros, so two dots is the equivalent of checking the parent directory of cwd,
i.e., $HOME.

ROS USAGE
source $(command rospack find planetexp_vision)/oak_d/init_oak_d_streamer <args>
"""

# Import required packages for backwards compability
from __future__ import print_function
# Print python interpreter
import sys
print("[INFO] Python interpreter path: " + sys.executable)

# Remove Python Path from ROS melodic to avoid conflicts with OpenVINO Optimized OpenCV.
sys.path.remove('/opt/ros/melodic/lib/python2.7/dist-packages')
# Check invoked version of OpenCV package
import numpy as np
import cv2
print("[INFO] OpenCV module version: " + cv2.__version__)
if(cv2.__version__[6:] != "openvino"):
    sys.exit("[ERROR] Wrong OpenCV version. Aborting ...")

# Reinsert removed Python Path from ROS melodic
sys.path.append('/opt/ros/melodic/lib/python2.7/dist-packages')

# Import required packages
from sensor_msgs.msg import CompressedImage
import rospy
# from tf.transformations import euler_from_quaternion
import argparse
import depthai

def frame_publisher_ROS(args):
    # ROS variables
    try:
        width_res = rospy.get_param("/camera_model/width_res")
        height_res = rospy.get_param("/camera_model/height_res")
        pub_rate = rospy.get_param("/camera_model/pub_rate")
    except rospy.ROSException:
        rospy.logerr("Could not get parameters for visionSensor.")
        exit(0)
    frame_publisher = rospy.Publisher(
        args["node_ns"] + "/image_raw/compressed",
        CompressedImage,
        queue_size=1)
    publisher_rate = rospy.Rate(pub_rate)

    # OAK-D variables

    # Pipeline tells DepthAI what operations to perform when running - you define all of the resources used and flows here
    pipeline = depthai.Pipeline()

    # First, we want the Color camera as the output
    cam_rgb = pipeline.createColorCamera()
    cam_rgb.setPreviewSize(width_res, height_res)
    cam_rgb.setInterleaved(False)

    # XLinkOut is a "way out" from the device. Any data you want to transfer to host need to be send via XLink
    xout_rgb = pipeline.createXLinkOut()
    # For the rgb camera output, we want the XLink stream to be named "rgb"
    xout_rgb.setStreamName("rgb")
    # Linking camera preview to XLink input, so that the frames will be sent to host
    cam_rgb.preview.link(xout_rgb.input)

    # Pipeline is now finished, and we need to find an available device to run our pipeline
    # we are using context manager here that will dispose the device after we stop using it
    with depthai.Device(pipeline) as device:
        # And start. From this point, the Device will be in "running" mode and will start sending data via XLink
        device.startPipeline()

        # To consume the device results, we get two output queues from the device, with stream names we assigned earlier
        q_rgb = device.getOutputQueue("rgb")

        # Here, some of the default values are defined. Frame will be an image from "rgb" stream.
        frame = None

        # Main host-side application loop
        while not rospy.is_shutdown():
            # we try to fetch the data from rgb queues. tryGet will return either the data packet or None if there isn't any
            in_rgb = q_rgb.tryGet()

            if in_rgb is not None:
                # When data from rgb stream is received, we need to transform it from 1D flat array into 3 x height x width one
                shape = (3, in_rgb.getHeight(), in_rgb.getWidth())
                # Also, the array is transformed from CHW form into HWC
                frame = in_rgb.getData().reshape(shape).transpose(1, 2, 0).astype(np.uint8)
                frame = np.ascontiguousarray(frame)

            if frame is not None:
                publish_raw_frame(frame_publisher, frame)

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

        rospy.loginfo_once("*************************")
        rospy.loginfo_once("* Frame Pub. Node Ready *")
        rospy.loginfo_once("*************************")

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
