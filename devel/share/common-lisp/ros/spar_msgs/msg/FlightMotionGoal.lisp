; Auto-generated. Do not edit!


(cl:in-package spar_msgs-msg)


;//! \htmlinclude FlightMotionGoal.msg.html

(cl:defclass <FlightMotionGoal> (roslisp-msg-protocol:ros-message)
  ((motion
    :reader motion
    :initarg :motion
    :type cl:fixnum
    :initform 0)
   (position
    :reader position
    :initarg :position
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (yaw
    :reader yaw
    :initarg :yaw
    :type cl:float
    :initform 0.0)
   (velocity_vertical
    :reader velocity_vertical
    :initarg :velocity_vertical
    :type cl:float
    :initform 0.0)
   (velocity_horizontal
    :reader velocity_horizontal
    :initarg :velocity_horizontal
    :type cl:float
    :initform 0.0)
   (yawrate
    :reader yawrate
    :initarg :yawrate
    :type cl:float
    :initform 0.0)
   (wait_for_convergence
    :reader wait_for_convergence
    :initarg :wait_for_convergence
    :type cl:boolean
    :initform cl:nil)
   (position_radius
    :reader position_radius
    :initarg :position_radius
    :type cl:float
    :initform 0.0)
   (yaw_range
    :reader yaw_range
    :initarg :yaw_range
    :type cl:float
    :initform 0.0))
)

(cl:defclass FlightMotionGoal (<FlightMotionGoal>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FlightMotionGoal>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FlightMotionGoal)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name spar_msgs-msg:<FlightMotionGoal> is deprecated: use spar_msgs-msg:FlightMotionGoal instead.")))

(cl:ensure-generic-function 'motion-val :lambda-list '(m))
(cl:defmethod motion-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:motion-val is deprecated.  Use spar_msgs-msg:motion instead.")
  (motion m))

(cl:ensure-generic-function 'position-val :lambda-list '(m))
(cl:defmethod position-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:position-val is deprecated.  Use spar_msgs-msg:position instead.")
  (position m))

(cl:ensure-generic-function 'yaw-val :lambda-list '(m))
(cl:defmethod yaw-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:yaw-val is deprecated.  Use spar_msgs-msg:yaw instead.")
  (yaw m))

(cl:ensure-generic-function 'velocity_vertical-val :lambda-list '(m))
(cl:defmethod velocity_vertical-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:velocity_vertical-val is deprecated.  Use spar_msgs-msg:velocity_vertical instead.")
  (velocity_vertical m))

(cl:ensure-generic-function 'velocity_horizontal-val :lambda-list '(m))
(cl:defmethod velocity_horizontal-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:velocity_horizontal-val is deprecated.  Use spar_msgs-msg:velocity_horizontal instead.")
  (velocity_horizontal m))

(cl:ensure-generic-function 'yawrate-val :lambda-list '(m))
(cl:defmethod yawrate-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:yawrate-val is deprecated.  Use spar_msgs-msg:yawrate instead.")
  (yawrate m))

(cl:ensure-generic-function 'wait_for_convergence-val :lambda-list '(m))
(cl:defmethod wait_for_convergence-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:wait_for_convergence-val is deprecated.  Use spar_msgs-msg:wait_for_convergence instead.")
  (wait_for_convergence m))

(cl:ensure-generic-function 'position_radius-val :lambda-list '(m))
(cl:defmethod position_radius-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:position_radius-val is deprecated.  Use spar_msgs-msg:position_radius instead.")
  (position_radius m))

(cl:ensure-generic-function 'yaw_range-val :lambda-list '(m))
(cl:defmethod yaw_range-val ((m <FlightMotionGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:yaw_range-val is deprecated.  Use spar_msgs-msg:yaw_range instead.")
  (yaw_range m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<FlightMotionGoal>)))
    "Constants for message type '<FlightMotionGoal>"
  '((:MOTION_STOP . 0)
    (:MOTION_GOTO . 1)
    (:MOTION_GOTO_POS . 2)
    (:MOTION_GOTO_YAW . 3)
    (:MOTION_TAKEOFF . 4)
    (:MOTION_LAND . 5))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'FlightMotionGoal)))
    "Constants for message type 'FlightMotionGoal"
  '((:MOTION_STOP . 0)
    (:MOTION_GOTO . 1)
    (:MOTION_GOTO_POS . 2)
    (:MOTION_GOTO_YAW . 3)
    (:MOTION_TAKEOFF . 4)
    (:MOTION_LAND . 5))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FlightMotionGoal>) ostream)
  "Serializes a message object of type '<FlightMotionGoal>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'motion)) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'position) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'yaw))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'velocity_vertical))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'velocity_horizontal))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'yawrate))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'wait_for_convergence) 1 0)) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'position_radius))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'yaw_range))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FlightMotionGoal>) istream)
  "Deserializes a message object of type '<FlightMotionGoal>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'motion)) (cl:read-byte istream))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'position) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'yaw) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'velocity_vertical) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'velocity_horizontal) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'yawrate) (roslisp-utils:decode-single-float-bits bits)))
    (cl:setf (cl:slot-value msg 'wait_for_convergence) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'position_radius) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'yaw_range) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FlightMotionGoal>)))
  "Returns string type for a message object of type '<FlightMotionGoal>"
  "spar_msgs/FlightMotionGoal")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FlightMotionGoal)))
  "Returns string type for a message object of type 'FlightMotionGoal"
  "spar_msgs/FlightMotionGoal")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FlightMotionGoal>)))
  "Returns md5sum for a message object of type '<FlightMotionGoal>"
  "830b68dc04cce4ae8cd0b0280e7dd30a")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FlightMotionGoal)))
  "Returns md5sum for a message object of type 'FlightMotionGoal"
  "830b68dc04cce4ae8cd0b0280e7dd30a")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FlightMotionGoal>)))
  "Returns full string definition for message of type '<FlightMotionGoal>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Goal~%~%# Motion to execute~%uint8 MOTION_STOP = 0				# Stop in current place (ignores x/y/z/yaw/convergence)~%uint8 MOTION_GOTO = 1				# Fly to location (x/y/z/yaw)~%uint8 MOTION_GOTO_POS = 2			# Fly to location (x/y/z, maintain current yaw)~%uint8 MOTION_GOTO_YAW = 3			# Rotate at current location (ignores x/y/z)~%uint8 MOTION_TAKEOFF = 4			# Performs a take-off at current location to hight 'z' (ignores x/y/yaw)~%uint8 MOTION_LAND = 5				# Performs a landing at current location at vertical speed (ignores x/y/z/yaw)~%~%uint8 motion~%~%# Positional information (some things may be ignored, see above)~%geometry_msgs/Point position~%float32 yaw~%~%# Velocity information (some things may be ignored, see above)~%# Goal will act as \"setpoint\" if all velocities are ==0, values of <0 will be rejected~%# If all velocities are ==0, goal will imidiately be finished if not using \"wait_for_convergence\"~%# For multiple-directional motions (e.g. goto: motion in x/y/z/yaw), the slowest motion will~%# be used to coordinate the motion such that all motions finish at the same point in time~%float32 velocity_vertical			# Speed to ascend and descent~%float32 velocity_horizontal			# Speed to translate~%float32 yawrate						# Speed to rotate~%~%# Convergence information (wait until at location before marking 'complete')~%# If enabled, radius and range values of <=0 will be rejected~%# Note: Landing motions will do not accept \"wait_for_convergence\", but instead will continue~%#		landing until the action is either cancelled or the UAV is disarmed~%bool wait_for_convergence			# Enable \"wait for convergence\"~%float32 position_radius				# Positional radius around final location (bubble waypoint)~%float32 yaw_range					# Angular range around final direction (direction wedge)~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FlightMotionGoal)))
  "Returns full string definition for message of type 'FlightMotionGoal"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Goal~%~%# Motion to execute~%uint8 MOTION_STOP = 0				# Stop in current place (ignores x/y/z/yaw/convergence)~%uint8 MOTION_GOTO = 1				# Fly to location (x/y/z/yaw)~%uint8 MOTION_GOTO_POS = 2			# Fly to location (x/y/z, maintain current yaw)~%uint8 MOTION_GOTO_YAW = 3			# Rotate at current location (ignores x/y/z)~%uint8 MOTION_TAKEOFF = 4			# Performs a take-off at current location to hight 'z' (ignores x/y/yaw)~%uint8 MOTION_LAND = 5				# Performs a landing at current location at vertical speed (ignores x/y/z/yaw)~%~%uint8 motion~%~%# Positional information (some things may be ignored, see above)~%geometry_msgs/Point position~%float32 yaw~%~%# Velocity information (some things may be ignored, see above)~%# Goal will act as \"setpoint\" if all velocities are ==0, values of <0 will be rejected~%# If all velocities are ==0, goal will imidiately be finished if not using \"wait_for_convergence\"~%# For multiple-directional motions (e.g. goto: motion in x/y/z/yaw), the slowest motion will~%# be used to coordinate the motion such that all motions finish at the same point in time~%float32 velocity_vertical			# Speed to ascend and descent~%float32 velocity_horizontal			# Speed to translate~%float32 yawrate						# Speed to rotate~%~%# Convergence information (wait until at location before marking 'complete')~%# If enabled, radius and range values of <=0 will be rejected~%# Note: Landing motions will do not accept \"wait_for_convergence\", but instead will continue~%#		landing until the action is either cancelled or the UAV is disarmed~%bool wait_for_convergence			# Enable \"wait for convergence\"~%float32 position_radius				# Positional radius around final location (bubble waypoint)~%float32 yaw_range					# Angular range around final direction (direction wedge)~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FlightMotionGoal>))
  (cl:+ 0
     1
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'position))
     4
     4
     4
     4
     1
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FlightMotionGoal>))
  "Converts a ROS message object to a list"
  (cl:list 'FlightMotionGoal
    (cl:cons ':motion (motion msg))
    (cl:cons ':position (position msg))
    (cl:cons ':yaw (yaw msg))
    (cl:cons ':velocity_vertical (velocity_vertical msg))
    (cl:cons ':velocity_horizontal (velocity_horizontal msg))
    (cl:cons ':yawrate (yawrate msg))
    (cl:cons ':wait_for_convergence (wait_for_convergence msg))
    (cl:cons ':position_radius (position_radius msg))
    (cl:cons ':yaw_range (yaw_range msg))
))
