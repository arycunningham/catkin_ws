#!/usr/bin/env python3
import rospy
from std_msgs.msg import Bool
from gpiozero import Servo
from time import sleep



sub_a = None
servo = Servo(12)

def callback_a(msg_in):
	# A bool message contains one field called "data" which can be true or false
	# http://docs.ros.org/melodic/api/std_msgs/html/msg/Bool.html
	# XXX: The following "GPIO.output" should be replaced to meet the needs of your actuators!
	if msg_in.data:
		rospy.loginfo("Setting output high!")
		servo.max()
		sleep(1)
		servo.min()
		sleep(1)
	else:
		rospy.loginfo("Setting output low!")
		sleep(1)


def shutdown():
	# Clean up our ROS subscriber if they were set, avoids error messages in logs
	if sub_a is not None:
		sub_a.unregister()

	# XXX: Could perform some failsafe actions here!


if __name__ == '__main__':
	# Setup the ROS backend for this node
	rospy.init_node('actuator_controller', anonymous=True)

	# Setup the publisher for a single actuator (use additional subscribers for extra actuators)
	sub_a = rospy.Subscriber('/actuator_control/actuator_a', Bool, callback_a)

	# Make sure we clean up all our code before exiting
	rospy.on_shutdown(shutdown)

	# Loop forever
	rospy.spin()
