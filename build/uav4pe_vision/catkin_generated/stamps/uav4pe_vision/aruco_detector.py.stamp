#!/usr/bin/env python3

import cv2
import numpy as np
from cv_bridge import CvBridge, CvBridgeError

import rospy
from sensor_msgs.msg import CompressedImage

br = CvBridge()

arucoDict = cv2.aruco.Dictionary_get(cv2.aruco.DICT_5X5_50)
arucoParams = cv2.aruco.DetectorParameters_create()

pub_image = rospy.Publisher(
    '/processed_aruco/image/compressed', CompressedImage, queue_size=10)


def process():
    subTopic = '/oak_d_RGB/image_raw/compressed'
    # subTopic = '/depthai_node/image/compressed'
    if not rospy.is_shutdown():
        sub_img = rospy.Subscriber(
            subTopic, CompressedImage, img_callback)


def img_callback(msg_in):
    try:
        frame = br.compressed_imgmsg_to_cv2(msg_in)
    except CvBridgeError as e:
        rospy.logerr(e)

    frame = find_aruco(frame)

    msg = CompressedImage()
    msg.header.stamp = rospy.Time.now()
    msg.format = "jpeg"
    msg.data = np.array(cv2.imencode('.jpg', frame)[1]).tostring()

    pub_image.publish(msg) # self.br.cv2_to_imgmsg(frame, 'bgr8')

    cv2.imshow('frame', frame)
    cv2.waitKey(1)


def find_aruco(frame):
    (corners, ids, rejected) = cv2.aruco.detectMarkers(
        frame, arucoDict, parameters=arucoParams)

    if len(corners) > 0:
        ids = ids.flatten()

        for (markerCorner, markerID) in zip(corners, ids):
            corners = markerCorner.reshape((4, 2))
            (topLeft, topRight, bottomRight, bottomLeft) = corners

            topRight = (int(topRight[0]), int(topRight[1]))
            bottomRight = (int(bottomRight[0]), int(bottomRight[1]))
            bottomLeft = (int(bottomLeft[0]), int(bottomLeft[1]))
            topLeft = (int(topLeft[0]), int(topLeft[1]))

            cv2.line(frame, topLeft, topRight, (0, 255, 0), 2)
            cv2.line(frame, topRight, bottomRight, (0, 255, 0), 2)
            cv2.line(frame, bottomRight, bottomLeft, (0, 255, 0), 2)
            cv2.line(frame, bottomLeft, topLeft, (0, 255, 0), 2)

            # Draw a circle in the middle
            # cX = int((topLeft[0] + bottomRight[0]) / 2.0)
            # cY = int((topLeft[1] + bottomRight[1]) / 2.0)

            #cv2.circle(frame, (cX, cY), 5, (0, 0, 255), -1)
            rospy.loginfo("[VIS] Aruco detected, ID: {}".format(markerID))

            cv2.putText(frame, str(
                markerID), (topLeft[0], topLeft[1] - 15), cv2.FONT_HERSHEY_COMPLEX, 0.5, (0, 255, 0), 2)

    return frame


def main():
    rospy.init_node('uav4pe_vision_node', anonymous=True)

    rospy.loginfo("[VIS] Processing images...")

    process()
    rospy.spin()


if __name__ == '__main__':
    main()
