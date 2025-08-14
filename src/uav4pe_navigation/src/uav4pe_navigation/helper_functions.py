#!/usr/bin/env python3
# -*- coding: utf-8 -*-

############################### ############################### Libraries ###############################
############################### Author: shahzadbrar & Piaktipik
# Libraries for ROS
import rospy

############################### Helper functions

def check_waypoints(wps):
    if not isinstance(wps, list):
        rospy.logwarn("Waypoints are not a list")
        return False

    if len(wps) < 1:
        rospy.logwarn("Waypoints list is empty")
        return False

    for i in range(len(wps)):
        if not check_waypoint(wps[i]):
            rospy.logwarn("Waypoints %i did not pass check" % (i + 1))
            return False

    return True


def check_waypoint(wp):
    if not isinstance(wp, list):
        rospy.logwarn("Waypoint is not a list of coordinates")
        return False

    if len(wp) != 4:
        rospy.logwarn("Waypoint has an invalid length (must be X/Y/Z/YAW)")
        return False

    return True
