#!/usr/bin/env python3

import cv2
import numpy as np
from cv_bridge import CvBridge, CvBridgeError

import rospy
from std_msgs.msg import Int8
from sensor_msgs.msg import CompressedImage
from geometry_msgs.msg import Point
from uav4pe_navigation.map_nav import MAP
import argparse

class VISION():
    cvBridge = CvBridge()

    # Parameter for aruco detection
    arucoDict = cv2.aruco.Dictionary_get(cv2.aruco.DICT_5X5_250)
    arucoParams = cv2.aruco.DetectorParameters_create()

    # Thresholds for surface color detection
    lower_red = np.array([161, 155, 84])
    upper_red = np.array([179, 255, 255])
    lower_green = np.array([6, 44, 0])
    upper_green = np.array([85, 219, 203])

    # Parameters for surface detection
    stringSafe ='Safe'
    stringDanger ='Danger'
    # center_x_textOffset = cv2.getTextSize(self.stringSafe, cv2.FONT_HERSHEY_COMPLEX, 1, 2)[0]/2
    minAreaSurface = 5000      # minimun area to recognize surface 100x50

    # Topics for image/position source to be analyzed
    mapPose = '/planetexp_nav/map_pose'    # Topic from gazebo simulation
    subTopic = '/oak_d_RGB/image_raw/compressed'    # Topic from gazebo Emulation
    # subTopic = '/depthai_node/image/compressed'   # Topic from OAK-D cam

    def __init__(self,args):

        # General Code parameters
        self.simulation = args["simulation"] == "True"

        # Parameter for keep track of processed frames
        self.time_finished_processing = rospy.Time(0)
        
        # Publishers
        # Processed image with labels and ids detection
        self.pub_image = rospy.Publisher('/planetexp_vision/image/compressed', CompressedImage, queue_size=10)
        # Surface type detected
        self.pub_vision = rospy.Publisher('/planetexp_vision/surface_type', Int8, queue_size=10)

        # Subscribers
        if not rospy.is_shutdown():
            if self.simulation:
                # Image from map and position in the map from navigation simulation
                navPos = rospy.Subscriber(self.mapPose, Point, self.navMapPose_callback)
                self.map = MAP()
            else:
                # Image from the vision system
                sub_img = rospy.Subscriber(self.subTopic, CompressedImage, self.img_callback)

    # Callback surface type to be generated from map and navMapPose
    def navMapPose_callback(self, msg_in):
        navMapPose = msg_in
        surfaceUnder = self.map.map[int(navMapPose.x)][int(navMapPose.y)]

        # Encode surface types
        msg_vision = np.int8(1) # Default: SURFACE TYPE: Unkown (U)
        if surfaceUnder == self.map.T:  # SURFACE TYPE: TARGET (T)
            msg_vision = np.int8(2)
        elif surfaceUnder == self.map.R:  # SURFACE TYPE: Dangerous (D)
            msg_vision = np.int8(-3)
        elif surfaceUnder == self.map.G:  # SURFACE TYPE: Safe (S)
            msg_vision = np.int8(0)
        
        # Publish surface type detected
        self.pub_vision.publish(msg_vision)

    # Callback image to be processed
    def img_callback(self, msg_in):
        # Skip images received during image processing
        if msg_in.header.stamp > self.time_finished_processing:
            # Capure new frame from msg to cv2
            try:
                frame = self.cvBridge.compressed_imgmsg_to_cv2(msg_in)
            except CvBridgeError as e:
                rospy.logerr(e)

            # Run detections
            frame, colour = self.detect_colour(frame)
            frame, markerID = self.find_aruco(frame)

            # Encode surface types
            if markerID != 10000:  # SURFACE TYPE: TARGET (T)
                msg_vision = np.int8(2)
            elif colour == 'red':  # SURFACE TYPE: Dangerous (D)
                msg_vision = np.int8(-3)
            elif colour == 'green':  # SURFACE TYPE: Safe (S)
                msg_vision = np.int8(0)
            elif colour == 'black':  # SURFACE TYPE: Unkown (U)
                msg_vision = np.int8(1)
            
            # Publish surface type detected
            self.pub_vision.publish(msg_vision)

            # Prepare image processed message 
            msg = CompressedImage()
            msg.header.stamp = rospy.Time.now()
            msg.format = "jpeg"
            msg.data = np.array(cv2.imencode('.jpg', frame)[1]).tostring()
            # Publish processed image msg
            self.pub_image.publish(msg)  # self.cvBridge.cv2_to_imgmsg(frame, 'bgr8')
            # Update last time processed image 
            self.time_finished_processing = rospy.Time.now()

        # cv2.imshow('frame', frame)
        # cv2.waitKey(1)

    # Process and return frame updated and last markerID
    def find_aruco(self, frame):
        # Apply image enhancement to improve detection
        # frame = self.increase_contrast(frame)
        frame = self.apply_brightness_contrast(frame, 127, 0)
        # Default market Id
        markerID = 10000

        # Run OpenCV aruco detection code
        # corners -> vector of detected marker corners in all frames
        # id -> list of identifiers for each marker in corners
        (corners, ids, rejected) = cv2.aruco.detectMarkers(
            frame, self.arucoDict, parameters=self.arucoParams)

        # Check if any detection
        if len(corners) > 0:
            ids = ids.flatten()
            # For each corners and ids
            for (markerCorner, markerID) in zip(corners, ids):
                # Extract corners coordinates
                corners = markerCorner.reshape((4, 2))
                (topLeft, topRight, bottomRight, bottomLeft) = corners
                # Round to int corners coordinates
                topRight = (int(topRight[0]), int(topRight[1]))
                bottomRight = (int(bottomRight[0]), int(bottomRight[1]))
                bottomLeft = (int(bottomLeft[0]), int(bottomLeft[1]))
                topLeft = (int(topLeft[0]), int(topLeft[1]))
                # Draw a box using the corners coordinates
                cv2.line(frame, topLeft, topRight, (0, 255, 0), 2)
                cv2.line(frame, topRight, bottomRight, (0, 255, 0), 2)
                cv2.line(frame, bottomRight, bottomLeft, (0, 255, 0), 2)
                cv2.line(frame, bottomLeft, topLeft, (0, 255, 0), 2)

                # Draw a circle in the middle
                # cX = int((topLeft[0] + bottomRight[0]) / 2.0)
                # cY = int((topLeft[1] + bottomRight[1]) / 2.0)

                #cv2.circle(frame, (cX, cY), 5, (0, 0, 255), -1)
                # rospy.loginfo("[VIS] Aruco detected, ID: {}".format(markerID))

                # Place Id as text on the top lef corner.
                cv2.putText(frame, str(
                    markerID), (topLeft[0], topLeft[1] - 15), cv2.FONT_HERSHEY_COMPLEX, 0.5, (0, 255, 0), 2)
        # Return updated frame and last markerID
        return frame, markerID

    # Return the frame with marked colors and the colour detected
    def detect_colour(self, frame):
        # Default parameters
        colour = 'black'
        maxRedArea = 0
        maxGreenArea = 0
        # Change color space to HSV
        hsv_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        # Check thresholds for red and green
        red_mask = cv2.inRange(hsv_frame, self.lower_red, self.upper_red)
        gre_mask = cv2.inRange(hsv_frame, self.lower_green, self.upper_green)

        # Bitwise_and
        #red_colour = cv2.bitwise_and(frame, frame, mask=red_mask)
        #gre_colour = cv2.bitwise_and(frame, frame, mask=gre_mask)

        # Blur the Masks
        maskFiltered_red = cv2.medianBlur(red_mask, 5)  
        maskFiltered_gre = cv2.medianBlur(gre_mask, 5)
        # Dilate the mask
        kernel_dilate = np.ones((10, 10), np.uint8)
        maskDilated_red = cv2.dilate(maskFiltered_red, kernel_dilate, iterations=0)
        maskDilated_gre = cv2.dilate(maskFiltered_gre, kernel_dilate, iterations=0)
        # Generate contours
        contour_red, _ = cv2.findContours(maskDilated_red, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        contour_gre, _ = cv2.findContours(maskDilated_gre, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

        # Pick the max red area between all red contours
        for c in contour_red:
            x, y, w, h = cv2.boundingRect(c)
            red_rect = cv2.minAreaRect(c)
            center_x = round(x + (w/2))
            center_y = round(y + (h/2))
            # Compute area
            red_area = w * h

            # Pick the max red area
            if maxRedArea < red_area:
                maxRedArea = red_area

            # Visualize red areas detected
            if red_area > self.minAreaSurface:
                # Compute area
                box = cv2.boxPoints(red_rect)
                box = np.int0(box)
                # Draw box and place text
                cv2.drawContours(frame, [box], 0, (0, 0, 255), 2)
                cv2.putText(frame, self.stringDanger, (center_x, center_y),cv2.FONT_HERSHEY_COMPLEX, 0.5, (0, 0, 255))
        # Pick the max green area between all green contours
        for c in contour_gre:
            x, y, w, h = cv2.boundingRect(c)
            gre_rect = cv2.minAreaRect(c)
            center_x = round(x + (w/2))
            center_y = round(y + (h/2))
            # Compute area
            gre_area = w * h

            # Pick the max red area
            if maxGreenArea < gre_area:
                maxGreenArea = gre_area

            # Visualize green areas detected
            if gre_area > self.minAreaSurface:
                gre_box = cv2.boxPoints(gre_rect)
                gre_box = np.int0(gre_box)
                # Draw box and place text
                cv2.drawContours(frame, [gre_box], 0, (0, 255, 0), 2)
                cv2.putText(frame, self.stringSafe, (center_x, center_y), cv2.FONT_HERSHEY_COMPLEX, 0.5, (0, 255, 0))
        
        # Pick the bigger area color
        if maxRedArea > maxGreenArea:
            colour = 'red'
        elif maxRedArea <= maxGreenArea:
            colour = 'green'

        # Return the frame with marked colors and the colour detected
        return frame, colour

    def increase_contrast(self, image):
        lab = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
        l, a, b = cv2.split(lab)
        clahe = cv2.createCLAHE(clipLimit=3.0, tileGridSize=(8,8))
        cl = clahe.apply(l)
        limg = cv2.merge((cl,a,b))
        ic_im = cv2.cvtColor(limg, cv2.COLOR_LAB2BGR)
        return ic_im

    def apply_brightness_contrast(self, input_img, brightness = 0, contrast = 0):
        if brightness != 0:
            if brightness > 0:
                shadow = brightness
                highlight = 255
            else:
                shadow = 0
                highlight = 255 + brightness
            alpha_b = (highlight - shadow)/255
            gamma_b = shadow
            
            buf = cv2.addWeighted(input_img, alpha_b, input_img, 0, gamma_b)
        else:
            buf = input_img.copy()
        
        if contrast != 0:
            f = 131*(contrast + 127)/(127*(131-contrast))
            alpha_c = f
            gamma_c = 127*(1-f)
            
            buf = cv2.addWeighted(buf, alpha_c, buf, 0, gamma_c)

        return buf


# Main code launch with arguments
def main(args):
    rospy.init_node('planetexp_vision', anonymous=True)
    rospy.loginfo("[VIS] Processing images...")
    print(args)
    vis = VISION(args)
    rospy.spin()

def arg_parser(raw_args=None):
    # construct the argument parse and parse the arguments.
    ap = argparse.ArgumentParser()
    ap.add_argument("-sim", "--simulation", required=False, default="False",
                    help="Simulation Argument")
    if raw_args is None:
        args = vars(ap.parse_args(rospy.myargv()[1:]))
    else:
        args = vars(ap.parse_args(raw_args))
    
    return args

if __name__ == '__main__':
    try:
        args = arg_parser()
        main(args)
    except rospy.ROSInterruptException as e:
        rospy.logerr(e)
