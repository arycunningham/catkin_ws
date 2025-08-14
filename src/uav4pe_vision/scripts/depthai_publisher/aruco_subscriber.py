#!/usr/bin/env python3

import cv2

import rospy
from sensor_msgs.msg import CompressedImage
from cv_bridge import CvBridge, CvBridgeError
import numpy as np
# Libs for Aruco frame generation
import tf, tf2_ros
import math
from std_msgs.msg import Time
from geometry_msgs.msg import TransformStamped

class ArucoDetector():
    aruco_dict = cv2.aruco.Dictionary_get(cv2.aruco.DICT_5X5_100) 
    # aruco_dict = cv2.aruco.Dictionary_get(cv2.aruco.DICT_ARUCO_ORIGINAL) 
    aruco_params = cv2.aruco.DetectorParameters_create()

    frame_sub_topic = '/oak_d_RGB/image_raw/compressed'
    # camera_matrix
    # mtx = np.array([[623.680552, 0, (256/2)], [0, 623.680552, (192/2)], [0, 0, 1]], dtype=np.float)
    mtx = np.array([[256.0, 0.0, 128.0],[0.0, 192.0, 96.0],[0.0, 0.0, 1.0]], dtype=np.float)
    
    # distortion_coefficients
    dist = np.array([[0, 0, 0, 0]], dtype=np.float)

    # Class Variables fro aruco frame
    tfbr = None
    pub_found = None

    camera_name = "camera"
    aruco_name = "aruco_"
        
    def __init__(self):
        self.aruco_pub = rospy.Publisher(
            '/processed_aruco/image/compressed', CompressedImage, queue_size=10)

        self.br = CvBridge()

        # Setup tf2 broadcaster and timestamp publisher
        self.tfbr = tf2_ros.TransformBroadcaster()
        self.pub_found = rospy.Publisher('/aruco_found', Time, queue_size=10)

        if not rospy.is_shutdown():
            self.frame_sub = rospy.Subscriber(
                self.frame_sub_topic, CompressedImage, self.img_callback)

    def img_callback(self, msg_in):
        try:
            frame = self.br.compressed_imgmsg_to_cv2(msg_in)
        except CvBridgeError as e:
            rospy.logerr(e)

        aruco = self.find_aruco(frame)
        self.publish_to_ros(aruco)

        # cv2.imshow('aruco', aruco)
        # cv2.waitKey(1)

    def find_aruco(self, frame):
        (corners, ids, _) = cv2.aruco.detectMarkers(
            frame, self.aruco_dict, parameters=self.aruco_params)

        if len(corners) > 0:
            ids = ids.flatten()

            for (marker_corner, marker_ID) in zip(corners, ids):
                corners = marker_corner.reshape((4, 2))
                (top_left, top_right, bottom_right, bottom_left) = corners

                top_right = (int(top_right[0]), int(top_right[1]))
                bottom_right = (int(bottom_right[0]), int(bottom_right[1]))
                bottom_left = (int(bottom_left[0]), int(bottom_left[1]))
                top_left = (int(top_left[0]), int(top_left[1]))

                cv2.line(frame, top_left, top_right, (0, 255, 0), 2)
                cv2.line(frame, top_right, bottom_right, (0, 255, 0), 2)
                cv2.line(frame, bottom_right, bottom_left, (0, 255, 0), 2)
                cv2.line(frame, bottom_left, top_left, (0, 255, 0), 2)

                rospy.loginfo("Aruco detected, ID: {}".format(marker_ID))

                cv2.putText(frame, str(
                    marker_ID), (top_left[0], top_right[1] - 15), cv2.FONT_HERSHEY_COMPLEX, 0.5, (0, 255, 0), 2)
                # draw frames on arucos
                lenght_marker=0.15
                rvec, tvec, markerPoints = cv2.aruco.estimatePoseSingleMarkers(marker_corner, lenght_marker, self.mtx, self.dist)
                cv2.drawFrameAxes(frame, self.mtx, self.dist, rvec, tvec, 0.05)

                # print(markerPoints)

                self.send_tf_target(rvec,tvec,marker_ID)

        return frame

    def publish_to_ros(self, frame):
        if frame is not None:
            msg_out = CompressedImage()
            msg_out.header.stamp = rospy.Time.now()
            msg_out.format = "jpeg"
            msg_out.data = np.array(cv2.imencode('.jpg', frame)[1]).tostring()

            self.aruco_pub.publish(msg_out)

    def send_tf_target(self, rvec, tvec, id):
        # Generate our "found" timestamp
        time_found = rospy.Time.now()

        # Create a transform arbitrarily in the
        # camera frame
        t = TransformStamped()
        t.header.stamp = time_found
        t.header.frame_id = self.camera_name
        t.child_frame_id = self.aruco_name + str(id)
        # In here we need a code to get the target location relative to the camera (Perhaps solve PnP)
        # print("rvec: ")
        # print(rvec)
        # print("tvec: ")
        # print (tvec)
        # Normalize the rotation vector
        # rvec_norm = cv2.normalize(rvec, rvec)
        # Convert rotation vector to rotation matrix
        rotation_matrix, _ = cv2.Rodrigues(rvec)
        
        # Add a 90-degree rotation in the Z-axis
        # rotation_matrix_z = tf.transformations.rotation_matrix(np.pi / 2, (0, 0, 1))
        # rotation_matrix = np.dot(rotation_matrix, rotation_matrix_z[:3, :3])

        # Create a homogeneous transformation matrix
        homogeneous_matrix = np.eye(4)
        homogeneous_matrix[:3, :3] = rotation_matrix
        homogeneous_matrix[:3, 3] = tvec.squeeze()

        # Extract the quaternion from the homogeneous transformation matrix
        quaternion = tf.transformations.quaternion_from_matrix(homogeneous_matrix)

        # Once we know where the target is, relative to the camera frame, we create and sent that transform (relative position target to camera)
        tx = tvec[0][0][0]
        ty = tvec[0][0][1]
        tz = tvec[0][0][2]    # - altitude of the UAV camera Z.

        print("Translation x: {}, y: {}, z: {}".format(tx,ty,tz))
        print("Quaternion: w: {}, x: {}, y: {}, z: {} ".format(quaternion[0],quaternion[1],quaternion[2],quaternion[3]))
        
        t.transform.translation.x = tx
        t.transform.translation.y = ty
        t.transform.translation.z = tz

        t.transform.rotation.x = quaternion[0]
        t.transform.rotation.y = quaternion[1]
        t.transform.rotation.z = quaternion[2]
        t.transform.rotation.w = quaternion[3]
        
        # Send the transformation to TF
        # and "found" timestamp to localiser
        self.tfbr.sendTransform(t)
        self.pub_found.publish(time_found)


def main():
    rospy.init_node('EGB349_vision', anonymous=True)
    rospy.loginfo("Processing images...")

    aruco_detect = ArucoDetector()

    rospy.spin()
