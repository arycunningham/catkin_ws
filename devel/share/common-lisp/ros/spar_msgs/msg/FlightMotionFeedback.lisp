; Auto-generated. Do not edit!


(cl:in-package spar_msgs-msg)


;//! \htmlinclude FlightMotionFeedback.msg.html

(cl:defclass <FlightMotionFeedback> (roslisp-msg-protocol:ros-message)
  ((progress
    :reader progress
    :initarg :progress
    :type cl:float
    :initform 0.0)
   (waiting_for_convergence
    :reader waiting_for_convergence
    :initarg :waiting_for_convergence
    :type cl:boolean
    :initform cl:nil)
   (goal_position
    :reader goal_position
    :initarg :goal_position
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (goal_yaw
    :reader goal_yaw
    :initarg :goal_yaw
    :type cl:float
    :initform 0.0))
)

(cl:defclass FlightMotionFeedback (<FlightMotionFeedback>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FlightMotionFeedback>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FlightMotionFeedback)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name spar_msgs-msg:<FlightMotionFeedback> is deprecated: use spar_msgs-msg:FlightMotionFeedback instead.")))

(cl:ensure-generic-function 'progress-val :lambda-list '(m))
(cl:defmethod progress-val ((m <FlightMotionFeedback>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:progress-val is deprecated.  Use spar_msgs-msg:progress instead.")
  (progress m))

(cl:ensure-generic-function 'waiting_for_convergence-val :lambda-list '(m))
(cl:defmethod waiting_for_convergence-val ((m <FlightMotionFeedback>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:waiting_for_convergence-val is deprecated.  Use spar_msgs-msg:waiting_for_convergence instead.")
  (waiting_for_convergence m))

(cl:ensure-generic-function 'goal_position-val :lambda-list '(m))
(cl:defmethod goal_position-val ((m <FlightMotionFeedback>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:goal_position-val is deprecated.  Use spar_msgs-msg:goal_position instead.")
  (goal_position m))

(cl:ensure-generic-function 'goal_yaw-val :lambda-list '(m))
(cl:defmethod goal_yaw-val ((m <FlightMotionFeedback>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader spar_msgs-msg:goal_yaw-val is deprecated.  Use spar_msgs-msg:goal_yaw instead.")
  (goal_yaw m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FlightMotionFeedback>) ostream)
  "Serializes a message object of type '<FlightMotionFeedback>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'progress))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'waiting_for_convergence) 1 0)) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'goal_position) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'goal_yaw))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FlightMotionFeedback>) istream)
  "Deserializes a message object of type '<FlightMotionFeedback>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'progress) (roslisp-utils:decode-single-float-bits bits)))
    (cl:setf (cl:slot-value msg 'waiting_for_convergence) (cl:not (cl:zerop (cl:read-byte istream))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'goal_position) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'goal_yaw) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FlightMotionFeedback>)))
  "Returns string type for a message object of type '<FlightMotionFeedback>"
  "spar_msgs/FlightMotionFeedback")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FlightMotionFeedback)))
  "Returns string type for a message object of type 'FlightMotionFeedback"
  "spar_msgs/FlightMotionFeedback")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FlightMotionFeedback>)))
  "Returns md5sum for a message object of type '<FlightMotionFeedback>"
  "6f23ddce6055aec8d4fbc59ea65c4cb8")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FlightMotionFeedback)))
  "Returns md5sum for a message object of type 'FlightMotionFeedback"
  "6f23ddce6055aec8d4fbc59ea65c4cb8")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FlightMotionFeedback>)))
  "Returns full string definition for message of type '<FlightMotionFeedback>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%~%# Feedback~%~%float32 progress					# Progress 0..1 from start to goal~%bool waiting_for_convergence		# Mark to show if waiting for convergence~%~%geometry_msgs/Point goal_position	# Current goal position~%float32 goal_yaw					# Current goal yaw~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FlightMotionFeedback)))
  "Returns full string definition for message of type 'FlightMotionFeedback"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%~%# Feedback~%~%float32 progress					# Progress 0..1 from start to goal~%bool waiting_for_convergence		# Mark to show if waiting for convergence~%~%geometry_msgs/Point goal_position	# Current goal position~%float32 goal_yaw					# Current goal yaw~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FlightMotionFeedback>))
  (cl:+ 0
     4
     1
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'goal_position))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FlightMotionFeedback>))
  "Converts a ROS message object to a list"
  (cl:list 'FlightMotionFeedback
    (cl:cons ':progress (progress msg))
    (cl:cons ':waiting_for_convergence (waiting_for_convergence msg))
    (cl:cons ':goal_position (goal_position msg))
    (cl:cons ':goal_yaw (goal_yaw msg))
))
