#!/usr/bin/env python3
# -*- coding: utf-8 -*-

############################### ############################### Libraries ###############################
############################### Author: Piaktipik & shahzadbrar
# Libraries for debuging
# import debugpy
# debugpy.listen(5678)
# debugpy.wait_for_client()
# Libraries to launch ROS files
from math import *
from re import U
import time
import numpy as np
# Libraries for ROS
import rospy
import actionlib
from actionlib_msgs.msg import GoalStatus
# Libraries for ROS mavros
import mavros
from mavros_msgs.srv import SetMode
from mavros_msgs.msg import State
from mavros.utils import *
from mavros.param import *
from mavros import command
# Libraries for ROS messages
from std_msgs.msg import UInt8, Int64, Float32
from sensor_msgs.msg import BatteryState
from nav_msgs.msg import Path
from geometry_msgs.msg import Point, PoseStamped
# Libraries for QUTAS flight stack
from spar_msgs.msg import FlightMotionAction, FlightMotionGoal
from breadcrumb.srv import RequestPath, RequestPathRequest
# Libraries for uav4pe_navigation helpers
from uav4pe_navigation.helper_functions import *
from uav4pe_navigation.map_nav import MAP
# Experiments configuration
from datetime import datetime as dt     #  datetime module

############################### ############################### Parameters ###############################
### Experiments names
experimentTime = dt.now().strftime("%y-%m-%dT%H-%M-%S")         # Load time
############################### Base path 
absolute_path = os.path.dirname(os.path.abspath(__file__))
relative_path = "../../.."
basePath = os.path.abspath(os.path.join(absolute_path, relative_path))
logFileName = f'{basePath}/uav4pe_navigation/navigation_logs/{experimentTime}.txt'
print(f'Loading Configurations from: {logFileName}...')

# Global Vars Actions:
STAY_ON_GROUND = UInt8(0)
# TAKEOFF = UInt8(1)
HOVER = UInt8(1)
H_EXPLORATION = UInt8(2)
V_INSPECTION = UInt8(3)
LAND = UInt8(4)

# Global Vars Status:
LANDED_STAT = UInt8(0)
HOVERING_STAT = UInt8(1)
H_EXPLORATION_STAT = UInt8(2)
V_EXPLORATION_STAT = UInt8(3)
LANDING_STAT = UInt8(4)
CRASH_STAT = UInt8(5)

# Map Variables
# Variables used to center the map from the python matix to mavros offset-pose/cellsize.
offsetMapX = 8
offsetMapY = 8
marginOffset = 0.01   # Used to avoid rounding to 0.
cellsize =  0.25      # cell size in m

############################### ############################### Main ###############################

class Navigation():
    def __init__(self, args, waypoints, map):
        # Ensure waypoints are valid
        if not check_waypoints(waypoints):
            raise ValueError("Invalid waypoint list input")

        # Open Log file
        self.logFile = open(logFileName,'w')
        self.printAndSave("Using Map: {}".format(map.map2use))

        # General Code parameters
        self.simulation = args["simulation"] == "True"
        self.actionsTimeout = 10

        # UAV motion parameters 
        self.vel_linear = rospy.get_param("~vel_linear", 1)
        self.vel_yaw = rospy.get_param("~vel_yaw", 0.2)
        self.accuracy_pos = rospy.get_param("~acc_pos", 0.25)
        self.accuracy_yaw = rospy.get_param("~acc_yaw", 0.5)
        self.altitude4Explore = 1.2
        self.altitude4Inspect = 0.7
        self.altitude4Land = 0.3
        self.UAVArmed = False
        
        # load ans display waypoints/map
        self.wp_counter = 0
        self.wps = waypoints
        self.map = map
        self.mapExplored = 0.0            # Percentage of explored map
        self.mapOneCellExpValue = 1.0/self.map.explorableCells     # The value of explore one cell
        self.safeLandingReachable = 1.0   # UAV Range / Distance to safe landing location
        self.safeLandingPosition = [0.0, 0.0, self.altitude4Explore, 0.0]
        self.safeLandingDistance = 0.0
        self.UAVRange = 1.0               # UAV rage in m. This value depends mainly on the battery left * batCapcity to m factor.
        self.bat2meters = 2.0           # Conversion from batCapcity to m, from float batteryCapacity to m.
        display_path(self.wps)          # publish exploration path on RViz as rostopic
        self.printAndSave("Path published")

        # Flags to inspecting and hovering
        self.exploring = False
        # Location ans State of the UAV
        self.current_location = Point() # initialise the current location as a point
        self.mapPose = [0,0]    # Simple map coordinate position.
        self.current_state = LANDED_STAT # start off with the current state as LAND
        
        ########################## Topics definition
        # Topic from mission planner with command to execute
        self.topic_command = 'uav4pe_mission_planner/command'
        # Topics navigation module outcomes
        self.topic_current_state = 'uav4pe_navigation/state'
        self.topic_explored_percentage = 'uav4pe_navigation/explored'
        self.topic_safe_landing = 'uav4pe_navigation/safe_reachable'
        self.topic_map_pose = 'uav4pe_navigation/map_pose'

        # Topic used for simulation
        if self.simulation:
            self.topic_curr_pos = "/uavasr/pose"
            self.mavros_namespace = '/uavasr'
            self.topic_battery = '/uavasr/battery'
            self.printAndSave("Simulator topics loaded")
        else:
            # Topic used to connect with UAV
            self.topic_curr_pos = "/mavros/local_position/pose"
            self.mavros_namespace = '/mavros'
            self.topic_battery = '/mavros/battery'
            self.printAndSave("Mavros topics loaded")

        # Topic external sensor conection
        #self.topic_enviro_sensor = '/sensor_data'  # fix
        
        # Perception parameters and variables
        self.critical_battery = 0.10       # Battery threshold to trigger safe landing.
        self.battery_per = 0.7             # Baterry variable, updated in topic_battery
        self.health = 1                    # Healt flag, updated in uav_health timed callback, to commmand landing
        self.temperature = 30.0            # Temperature variable, updated in callback_enviro_sensor (not yet)
        self.light = 0                     # Light variable, updated in callback_enviro_sensor

        # Mavros control
        mavros.set_namespace(self.mavros_namespace)
        # Set Offboard Control and arm.
        self.mavros_set_state("OFFBOARD")       
        self.mavros_arm_disarm()

        # Publisher UAV Navigation status.
        self.pub_state = rospy.Publisher(self.topic_current_state, UInt8, queue_size=2)

        # Publisher UAV Navigation status.
        self.pub_explored = rospy.Publisher(self.topic_explored_percentage, Float32, queue_size=2)

        # Publisher UAV Navigation status.
        self.pub_safeLand = rospy.Publisher(self.topic_safe_landing, Float32, queue_size=2)

        # Publisher UAV Navigation mapPose.
        self.pub_mapPose = rospy.Publisher(self.topic_map_pose, Point, queue_size=2)

        # Create spar action client to command the UAV.
        action_ns = rospy.get_param("~action_topic", 'spar/flight')
        self.spar_client = actionlib.SimpleActionClient(action_ns, FlightMotionAction)
        self.printAndSave("Waiting for spar...")
        #self.spar_client.wait_for_server()

        # self.printAndSave("Waiting for breadcrumb...")
        # self.breadcrumb = '/breadcrumb/request_path'
        # rospy.wait_for_service(self.breadcrumb)
        # self.srvc_bc = rospy.ServiceProxy(
        #     self.breadcrumb, RequestPath)

        if not rospy.is_shutdown():
            self.printAndSave("waiting for command")
            # Subscriber for current pose
            self.sub_curr_pos = rospy.Subscriber(self.topic_curr_pos, PoseStamped, self.callback_pos) 
            # Subscriber for current command given by POMDP
            self.sub_command = rospy.Subscriber(self.topic_command, UInt8, self.callback_command) 
            # Subscriber for current battery
            self.sub_battery = rospy.Subscriber(self.topic_battery, BatteryState, self.callback_battery) 
            # Subscriber for environment sensor
            #self.sub_enviro_sensor = rospy.Subscriber(self.topic_enviro_sensor, Int64, self.callback_enviro_sensor) 

            # ------- Timer based functions 
            # 5Hz for exploration state (always waiting for a command)
            self.timer = rospy.Timer(rospy.Duration(1.0/5.0), self.explore_state, oneshot=False) 
            # 5Hz to publish state
            self.timer1 = rospy.Timer(rospy.Duration(1.0/5.0), self.publish_state, oneshot=False) 
            # 1Hz to check the health of the uav
            self.timer2 = rospy.Timer(rospy.Duration(1.0/1.0), self.uav_health, oneshot=False) 

            rospy.on_shutdown(lambda: self.shutdown())

# ZZZZZZZZZZZZZZZZZZZZZZZZZZ Callbacks ZZZZZZZZZZZZZZZZZZZZZZZZZZ 
    def callback_pos(self, msg_in):
        self.current_location = msg_in.pose.position
        self.mapPose = [offsetMapX-round(self.current_location.x/cellsize),offsetMapY-round(self.current_location.y/cellsize)]

        # Publish map_Pose
        msgMapPose = Point()
        msgMapPose.x = self.mapPose[0]
        msgMapPose.y = self.mapPose[1]
        msgMapPose.z = round(self.current_location.z/cellsize)
        self.pub_mapPose.publish(msgMapPose)

        # Compute how far is the landing place
        safePoseX = self.safeLandingPosition[0]
        safePoseY = self.safeLandingPosition[1]
        self.safeLandingDistance  = sqrt(pow(self.current_location.y - safePoseY, 2) + pow(self.current_location.x - safePoseX, 2))
        if self.safeLandingDistance > 1:      # Avoid divitions by 0 and have values over 1.
            self.safeLandingReachable = float(self.UAVRange) / self.safeLandingDistance
            if(self.safeLandingReachable > 1):
                self.safeLandingReachable = 1
        else:
            self.safeLandingReachable = 1.0


    def callback_command(self, msg_in):
        command = msg_in        # Get command from mission planner.

        if command == STAY_ON_GROUND:
            self.printAndSave("received: Stay on ground")
            self.landed()
        elif command == HOVER:
            self.printAndSave("received: Hover in place")
            self.hovering_state()
        elif command == H_EXPLORATION:
            self.printAndSave("received: Explore")
            self.exploring = True
        elif command == V_INSPECTION:
            self.printAndSave("received: Inspect")
            self.inspect_state()
        elif command == LAND:
            self.printAndSave("received: Land")
            self.land()
        elif command == UInt8(6):
            self.printAndSave("received: 0.25 m front")
            wp = [self.current_location.x + 0.25, self.current_location.y, self.current_location.z, 0.0]
            self.go_to_state(wp)
            self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))
        elif command == UInt8(7):
            self.printAndSave("received: 0.25 m back")
            wp = [self.current_location.x - 0.25, self.current_location.y, self.current_location.z, 0.0]
            self.go_to_state(wp)
            self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))
        elif command == UInt8(8):
            self.printAndSave("received: 0.25 m left")
            wp = [self.current_location.x, self.current_location.y + 0.25, self.current_location.z, 0.0]
            self.go_to_state(wp)
            self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))
        elif command == UInt8(9):
            self.printAndSave("received: 0.25 m right")
            wp = [self.current_location.x, self.current_location.y - 0.25, self.current_location.z, 0.0]
            self.go_to_state(wp)
            self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))
        else:
            self.printAndSave("received: unrecognized command: {}.".format(command))
        print("") # Print space to ensure command is registed in single line for analysis

    def callback_battery(self, msg_in):
        self.battery_per = msg_in.percentage
        self.UAVRange = self.bat2meters*self.battery_per

    def callback_enviro_sensor(self, msg_in):
        self.temperature = ""
        self.light = msg_in  # unit: lux

# ---- Timed callbacks
    # Default exploration state.
    def explore_state(self, timer=None):
        # If exploring is comanded
        if self.exploring:
            # Mission terminal state.
            if self.mapExplored > 0.999:
                self.printAndSave("Exploration Completed.")
                if self.current_state != LANDED_STAT:
                    print("Landing...")
                    self.land()
                elif self.current_state == LANDED_STAT:
                    self.shutdown()

            # If UAV on ground, take off
            elif self.current_state == LANDED_STAT:
                self.takeoff()
            self.current_state = H_EXPLORATION_STAT      # set exploring state.
            # ---------- Next available cell exploration
            nextMapPose = self.map.getNextCloseUnexploredCell(self.mapPose)
            self.printAndSave("Moving to un-explored cell: {}".format(nextMapPose))
            self.printAndSave("Explored: {} %".format(round(self.mapExplored*100,2)))
            nextWP = self.mapPose2Wp(nextMapPose)
            self.send_wp(nextWP) # Aim for the next waypoint
            # If the waypoint is processed ok, move to the next one, otherwise skipp and try again.
            if self.spar_client.get_state() == GoalStatus.SUCCEEDED:
                self.printAndSave("Reached cell {}".format(nextWP))
                # Mark map position as explored
                if(self.map.getCellType(nextMapPose) > 0):
                    self.map.map[nextMapPose[0]][nextMapPose[1]] = self.map.S
                    self.mapExplored += self.mapOneCellExpValue
                # Print map
                self.print_map(self.map)
                    

            elif (self.spar_client.get_state() == GoalStatus.PREEMPTED) or (self.spar_client.get_state() == GoalStatus.ABORTED) or (self.spar_client.get_state() == GoalStatus.REJECTED):
                self.printAndSave("explore_state, Skipping command. Spar state: {}.".format(self.spar_client.get_state()))

    def publish_state(self, timer=None):
        # Publish state
        msg = self.current_state
        rate = rospy.Rate(1)
        self.pub_state.publish(msg)
        # Publish percentage map explored
        msgExp = self.mapExplored
        rate = rospy.Rate(1)
        self.pub_explored.publish(msgExp)
        # Publish safe landing location reachability
        msgSR = self.safeLandingReachable
        rate = rospy.Rate(1)
        self.pub_safeLand.publish(msgSR)
        rate.sleep()

    def uav_health(self, timer=None):
        if self.battery_per <= self.critical_battery:
            self.printAndSave("Battery under critical level, Safe landing start.")
            self.health = 0
            self.land()
            self.mavros_arm_disarm()
            # rospy.signal_shutdown("[NAV] Emergency land completed.")
            self.printAndSave("Emergency land completed.")
            

# ZZZZZZZZZZZZZZZZZZZZZZZZZZ Actions ZZZZZZZZZZZZZZZZZZZZZZZZZZ 
    def takeoff(self):
        # Get ready to take off
        self.mavros_set_state("OFFBOARD")
        self.mavros_arm_disarm(True)

        goal = FlightMotionGoal()
        goal.motion = FlightMotionGoal.MOTION_TAKEOFF
        goal.position.z = self.altitude4Explore
        goal.velocity_vertical = self.vel_linear
        goal.wait_for_convergence = True
        goal.position_radius = self.accuracy_pos
        goal.yaw_range = self.accuracy_yaw

        rospy.sleep(3.0)
        self.printAndSave("Takeoff in progress...")
        self.spar_client.send_goal(goal)
        self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))

        result = self.spar_client.get_state()
        if result == GoalStatus.SUCCEEDED:
            self.printAndSave("Take-off complete!")
            # Set state to taking off
            self.current_state = HOVERING_STAT
        else:
            rospy.logerr("[NAV] Take-off failed!")

            # Detailed Feedback
            if result != GoalStatus.SUCCEEDED:
                if(result == GoalStatus.PENDING) or (result == GoalStatus.ACTIVE):
                    rospy.loginfo("Sent command to cancel current command")
                elif(result == GoalStatus.PREEMPTED):
                    rospy.logwarn("The current command was cancelled")
                elif(result == GoalStatus.ABORTED):
                    rospy.logwarn("The current command was aborted")
                elif(result == GoalStatus.RECALLED):
                    rospy.logerr("Error: The current command was recalled")
                elif(result == GoalStatus.REJECTED):
                    rospy.logerr("Error: The current command was rejected")
                else:
                    rospy.logerr("Error: An unknown goal status was recieved")

    def land(self):
        # Cancel current goal and set state to landing.
        self.cancel_goal()
        self.exploring = False
        self.current_state = LANDING_STAT

        self.printAndSave("Going to a safe zone... ")
        self.send_wp(self.safeLandingPosition)
        self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))
        # Land and set state to landed.
        self.printAndSave("Landing...")
        if self.simulation:
            self.send_wp([self.safeLandingPosition[0], self.safeLandingPosition[1], 0, 0.0])
            self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))
            self.mavros_arm_disarm()
        else:
            self.mavros_set_state("AUTO.LAND")
            time.sleep(2)
            self.mavros_arm_disarm()

        self.printAndSave("Landed.")
        self.current_state = LANDED_STAT

    def landed(self):
        # Cancel current goal and set state to landing.
        self.cancel_goal()
        self.exploring = False

        self.printAndSave("Check if landed")
        if self.current_location.z < self.altitude4Land and not self.UAVArmed:
            self.current_state = LANDED_STAT
            self.printAndSave("Landed.")
        else:
            self.land() # If not landed, landing is commanded
        

    def inspect_state(self):
        # If UAV on ground, take off
        if self.current_state == LANDED_STAT:
            self.takeoff()
        # Cancel current goal/action and set inpection state.
        self.cancel_goal()
        self.exploring = False
        self.current_state = V_EXPLORATION_STAT

        goal = FlightMotionGoal()
        goal.motion = FlightMotionGoal.MOTION_GOTO
        goal.position.x = self.current_location.x
        goal.position.y = self.current_location.y
        goal.position.z = self.altitude4Inspect
        goal.yaw = 0.0
        goal.velocity_vertical = self.vel_linear
        goal.velocity_horizontal = self.vel_linear
        goal.yawrate = self.vel_yaw
        goal.wait_for_convergence = True
        goal.position_radius = self.accuracy_pos
        goal.yaw_range = self.accuracy_yaw

        self.spar_client.send_goal(goal)
        self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))

    def hovering_state(self):
        # If UAV on ground, take off
        if self.current_state == LANDED_STAT:
            self.takeoff()
        # Cancel current goal/action and set hovering state.
        self.cancel_goal()
        self.exploring = False
        self.current_state = HOVERING_STAT
        
# ----------- Helpers for actions
    def cancel_goal(self, i=3):
        for _ in range(0, i):
            self.spar_client.cancel_goal()  # Try cancel goal multiple i times

    def go_to_state(self, wps):
        '''
        This function is used by the 0.25m f/b/l/r commands
        '''
        if self.spar_client.get_state() == GoalStatus.SUCCEEDED:
            self.send_wp(wps)
            self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))
            self.printAndSave("Reached waypoint.")
        elif (self.spar_client.get_state() == GoalStatus.PREEMPTED) or (self.spar_client.get_state() == GoalStatus.ABORTED) or (self.spar_client.get_state() == GoalStatus.REJECTED):
            self.printAndSave("go_to_state, Skipping command. Spar state: {}.".format(self.spar_client.get_state()))

    def mavros_set_state(self, state):
        '''
        Set the state of the PixRacer to OFFBOARD/AUTO.LAND/MANUAL etc.
        '''
        try:
            set_mode = rospy.ServiceProxy(mavros.get_topic('set_mode'), SetMode)
            ret = set_mode(base_mode=0, custom_mode=state)
            if not ret.mode_sent:
                rospy.logerr("[NAV] Request set_state failed.")

        except (rospy.ServiceException, IOError) as e:
            rospy.logerr(e)

    def mavros_arm_disarm(self, arm=False):
        '''
        Arm/disarm the UAV
        '''
        try:
            ret = command.arming(value=arm)
            if not ret.success:
                rospy.logerr("[NAV] Request arm_disarm failed.")
                self.UAVArmed = arm
            self.printAndSave("Request arm_disarm Result: %s." % bool(ret.result))

        except rospy.ServiceException as ex:
            rospy.logerr(ex)

    def send_wp(self, wp):
        '''
        Send waypoints to the flight controller
        '''
        if not check_waypoint(wp):
            raise ValueError("Invalid waypoint input.")

        goal = FlightMotionGoal()
        goal.motion = FlightMotionGoal.MOTION_GOTO
        goal.position.x = wp[0]
        goal.position.y = wp[1]
        goal.position.z = wp[2]
        goal.yaw = wp[3]
        goal.velocity_vertical = self.vel_linear
        goal.velocity_horizontal = self.vel_linear
        goal.yawrate = self.vel_yaw
        goal.wait_for_convergence = True
        goal.position_radius = self.accuracy_pos
        goal.yaw_range = self.accuracy_yaw

        self.spar_client.send_goal(goal)
        self.spar_client.wait_for_result(timeout=rospy.Duration(secs=self.actionsTimeout))

    # Not used for now
    def send_wp_bc(self, wp):
        '''
        Send waypoints using breadcrumb
        '''
        req = RequestPathRequest()

        req.start.x = self.current_location.x
        req.start.y = self.current_location.y
        req.start.z = self.current_location.z
        req.end.x = wp[0]
        req.end.y = wp[1]
        req.end.z = wp[2]
        yaw = wp[3]

        res = self.srvc_bc(req)

        if len(res.path.poses) == 1:
            self.send_wp(wp)
        else:
            for i in range(len(res.path.poses) - 1):

                x = res.path.poses[i].position.x
                y = res.path.poses[i].position.y
                z = wp[2]  # x = res.path.poses[i].position.x

                self.send_wp([x, y, z, yaw])

    # Used if ros_shutdown
    def shutdown(self):
        self.sub_curr_pos.unregister()
        self.spar_client.cancel_goal()
        self.printAndSave("Navigation stopped")
        self.logFile.close()
        rospy.signal_shutdown("Exploration completed")

    def mapPose2Wp(self, mapPose):
        # The current map cordinates need to be converted to local based coordinates.
        nextWPx = -cellsize*(float(mapPose[0])-offsetMapX)
        nextWPy = -cellsize*(float(mapPose[1])-offsetMapY)
        #self.printAndSave("Map cell: {} to WP: {}".format(mapPose,[nextWPx,nextWPy]))
        return [nextWPx,nextWPy, self.altitude4Explore, 0.0]

    def print_map(self,map):
        for x in map.map:
            for y in x:
                if y == map.T:
                    self.printAndSave("T",False)
                elif y == map.U:
                    self.printAndSave(".",False)
                elif y == map.G:
                    self.printAndSave("G",False)
                elif y == map.S:
                    self.printAndSave("x",False)
                elif y == map.X:
                    self.printAndSave("X",False)
                elif y == map.R:
                    self.printAndSave("R",False)
                else:
                    self.printAndSave("?",False)
            self.printAndSave("\n",False)
        #print(map.map)
        return True

    def printAndSave(self,message,send2Ros=True):
        self.logFile.write(message)
        if send2Ros:
            rospy.loginfo("[NAV] {}".format(message))
            self.logFile.write('\n')
            self.logFile.flush()
        else:
            print(message, end = '')
# ------------- End Navigation class

# ZZZZZZZZZZZZZZZZZZZZZZZZZZ General help funtions ZZZZZZZZZZZZZZZZZZZZZZZZZZ 
def display_path(wps):
    pub_path = rospy.Publisher(
        "/uav4pe_mission_planning/path", Path, queue_size=10, latch=True)
    msg = Path()
    msg.header.frame_id = "/map"
    msg.header.stamp = rospy.Time.now()

    for wp in wps:
        pose = PoseStamped()
        pose.pose.position.x = wp[0]
        pose.pose.position.y = wp[1]
        pose.pose.position.z = wp[2]

        pose.pose.orientation.w = 1.0
        pose.pose.orientation.x = 0.0
        pose.pose.orientation.y = 0.0
        pose.pose.orientation.z = 0.0

        msg.poses.append(pose)

    pub_path.publish(msg)

def mapVal(map2Check,pose2Check):
    # try to return the value in the map or X (UNKOWN) if fail
    try:
        valueCell = map2Check.map[offsetMapX-pose2Check[0]][offsetMapY-pose2Check[1]]
        print("ValueCell: {}".format(valueCell))
        return(valueCell)
    except Exception as e:
        print("Error: {}".format(e))
        return map2Check.X


# ZZZZZZZZZZZZZZZZZZZZZZZZZZ Main ZZZZZZZZZZZZZZZZZZZZZZZZZZ 
def main(args):
    # Node name start
    rospy.init_node('uav4pe_nav_node')

    # A mission composed by multiple waypoints.
    wps = [[-1.5, 1.5, 1.0, 0.0],
           [-1.5, -1.5, 1.0, 0.0],
           [-0.75, -1.5, 1.0, 0.0],
           [-0.75, 1.5, 1.0, 0.0],
           [0.0, 1.5, 1.0, 0.0],
           [0.0, -1.5, 1.0, 0.0],
           [0.75, -1.5, 1.0, 0.0],
           [0.75, 1.5, 1.0, 0.0],
           [1.5, 1.5, 1.0, 0.0],
           [1.5, -1.5, 1.0, 0.0]]
    # pick map for experiment
    map2test = MAP()
    rospy.loginfo("[NAV] Loading Map")
    ipose = [11,6]
    print(map2test.getNextCloseUnexploredCell(ipose))
    rospy.loginfo("[NAV] Ploting map")
    # uav4pe_Navigation start.
    rospy.loginfo("[NAV] Starting mission planning")
    print(args)
    nav = Navigation(args,wps,map2test)

    rospy.spin()