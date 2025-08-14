;; Auto-generated. Do not edit!


(when (boundp 'spar_msgs::FlightMotionGoal)
  (if (not (find-package "SPAR_MSGS"))
    (make-package "SPAR_MSGS"))
  (shadow 'FlightMotionGoal (find-package "SPAR_MSGS")))
(unless (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL")
  (make-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))

(in-package "ROS")
;;//! \htmlinclude FlightMotionGoal.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(intern "*MOTION_STOP*" (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(shadow '*MOTION_STOP* (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(defconstant spar_msgs::FlightMotionGoal::*MOTION_STOP* 0)
(intern "*MOTION_GOTO*" (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(shadow '*MOTION_GOTO* (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(defconstant spar_msgs::FlightMotionGoal::*MOTION_GOTO* 1)
(intern "*MOTION_GOTO_POS*" (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(shadow '*MOTION_GOTO_POS* (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(defconstant spar_msgs::FlightMotionGoal::*MOTION_GOTO_POS* 2)
(intern "*MOTION_GOTO_YAW*" (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(shadow '*MOTION_GOTO_YAW* (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(defconstant spar_msgs::FlightMotionGoal::*MOTION_GOTO_YAW* 3)
(intern "*MOTION_TAKEOFF*" (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(shadow '*MOTION_TAKEOFF* (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(defconstant spar_msgs::FlightMotionGoal::*MOTION_TAKEOFF* 4)
(intern "*MOTION_LAND*" (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(shadow '*MOTION_LAND* (find-package "SPAR_MSGS::FLIGHTMOTIONGOAL"))
(defconstant spar_msgs::FlightMotionGoal::*MOTION_LAND* 5)

(defun spar_msgs::FlightMotionGoal-to-symbol (const)
  (cond
        ((= const 0) 'spar_msgs::FlightMotionGoal::*MOTION_STOP*)
        ((= const 1) 'spar_msgs::FlightMotionGoal::*MOTION_GOTO*)
        ((= const 2) 'spar_msgs::FlightMotionGoal::*MOTION_GOTO_POS*)
        ((= const 3) 'spar_msgs::FlightMotionGoal::*MOTION_GOTO_YAW*)
        ((= const 4) 'spar_msgs::FlightMotionGoal::*MOTION_TAKEOFF*)
        ((= const 5) 'spar_msgs::FlightMotionGoal::*MOTION_LAND*)
        (t nil)))

(defclass spar_msgs::FlightMotionGoal
  :super ros::object
  :slots (_motion _position _yaw _velocity_vertical _velocity_horizontal _yawrate _wait_for_convergence _position_radius _yaw_range ))

(defmethod spar_msgs::FlightMotionGoal
  (:init
   (&key
    ((:motion __motion) 0)
    ((:position __position) (instance geometry_msgs::Point :init))
    ((:yaw __yaw) 0.0)
    ((:velocity_vertical __velocity_vertical) 0.0)
    ((:velocity_horizontal __velocity_horizontal) 0.0)
    ((:yawrate __yawrate) 0.0)
    ((:wait_for_convergence __wait_for_convergence) nil)
    ((:position_radius __position_radius) 0.0)
    ((:yaw_range __yaw_range) 0.0)
    )
   (send-super :init)
   (setq _motion (round __motion))
   (setq _position __position)
   (setq _yaw (float __yaw))
   (setq _velocity_vertical (float __velocity_vertical))
   (setq _velocity_horizontal (float __velocity_horizontal))
   (setq _yawrate (float __yawrate))
   (setq _wait_for_convergence __wait_for_convergence)
   (setq _position_radius (float __position_radius))
   (setq _yaw_range (float __yaw_range))
   self)
  (:motion
   (&optional __motion)
   (if __motion (setq _motion __motion)) _motion)
  (:position
   (&rest __position)
   (if (keywordp (car __position))
       (send* _position __position)
     (progn
       (if __position (setq _position (car __position)))
       _position)))
  (:yaw
   (&optional __yaw)
   (if __yaw (setq _yaw __yaw)) _yaw)
  (:velocity_vertical
   (&optional __velocity_vertical)
   (if __velocity_vertical (setq _velocity_vertical __velocity_vertical)) _velocity_vertical)
  (:velocity_horizontal
   (&optional __velocity_horizontal)
   (if __velocity_horizontal (setq _velocity_horizontal __velocity_horizontal)) _velocity_horizontal)
  (:yawrate
   (&optional __yawrate)
   (if __yawrate (setq _yawrate __yawrate)) _yawrate)
  (:wait_for_convergence
   (&optional (__wait_for_convergence :null))
   (if (not (eq __wait_for_convergence :null)) (setq _wait_for_convergence __wait_for_convergence)) _wait_for_convergence)
  (:position_radius
   (&optional __position_radius)
   (if __position_radius (setq _position_radius __position_radius)) _position_radius)
  (:yaw_range
   (&optional __yaw_range)
   (if __yaw_range (setq _yaw_range __yaw_range)) _yaw_range)
  (:serialization-length
   ()
   (+
    ;; uint8 _motion
    1
    ;; geometry_msgs/Point _position
    (send _position :serialization-length)
    ;; float32 _yaw
    4
    ;; float32 _velocity_vertical
    4
    ;; float32 _velocity_horizontal
    4
    ;; float32 _yawrate
    4
    ;; bool _wait_for_convergence
    1
    ;; float32 _position_radius
    4
    ;; float32 _yaw_range
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8 _motion
       (write-byte _motion s)
     ;; geometry_msgs/Point _position
       (send _position :serialize s)
     ;; float32 _yaw
       (sys::poke _yaw (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _velocity_vertical
       (sys::poke _velocity_vertical (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _velocity_horizontal
       (sys::poke _velocity_horizontal (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _yawrate
       (sys::poke _yawrate (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; bool _wait_for_convergence
       (if _wait_for_convergence (write-byte -1 s) (write-byte 0 s))
     ;; float32 _position_radius
       (sys::poke _position_radius (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _yaw_range
       (sys::poke _yaw_range (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _motion
     (setq _motion (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; geometry_msgs/Point _position
     (send _position :deserialize buf ptr-) (incf ptr- (send _position :serialization-length))
   ;; float32 _yaw
     (setq _yaw (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _velocity_vertical
     (setq _velocity_vertical (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _velocity_horizontal
     (setq _velocity_horizontal (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _yawrate
     (setq _yawrate (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; bool _wait_for_convergence
     (setq _wait_for_convergence (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;; float32 _position_radius
     (setq _position_radius (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _yaw_range
     (setq _yaw_range (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get spar_msgs::FlightMotionGoal :md5sum-) "830b68dc04cce4ae8cd0b0280e7dd30a")
(setf (get spar_msgs::FlightMotionGoal :datatype-) "spar_msgs/FlightMotionGoal")
(setf (get spar_msgs::FlightMotionGoal :definition-)
      "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
# Goal

# Motion to execute
uint8 MOTION_STOP = 0				# Stop in current place (ignores x/y/z/yaw/convergence)
uint8 MOTION_GOTO = 1				# Fly to location (x/y/z/yaw)
uint8 MOTION_GOTO_POS = 2			# Fly to location (x/y/z, maintain current yaw)
uint8 MOTION_GOTO_YAW = 3			# Rotate at current location (ignores x/y/z)
uint8 MOTION_TAKEOFF = 4			# Performs a take-off at current location to hight 'z' (ignores x/y/yaw)
uint8 MOTION_LAND = 5				# Performs a landing at current location at vertical speed (ignores x/y/z/yaw)

uint8 motion

# Positional information (some things may be ignored, see above)
geometry_msgs/Point position
float32 yaw

# Velocity information (some things may be ignored, see above)
# Goal will act as \"setpoint\" if all velocities are ==0, values of <0 will be rejected
# If all velocities are ==0, goal will imidiately be finished if not using \"wait_for_convergence\"
# For multiple-directional motions (e.g. goto: motion in x/y/z/yaw), the slowest motion will
# be used to coordinate the motion such that all motions finish at the same point in time
float32 velocity_vertical			# Speed to ascend and descent
float32 velocity_horizontal			# Speed to translate
float32 yawrate						# Speed to rotate

# Convergence information (wait until at location before marking 'complete')
# If enabled, radius and range values of <=0 will be rejected
# Note: Landing motions will do not accept \"wait_for_convergence\", but instead will continue
#		landing until the action is either cancelled or the UAV is disarmed
bool wait_for_convergence			# Enable \"wait for convergence\"
float32 position_radius				# Positional radius around final location (bubble waypoint)
float32 yaw_range					# Angular range around final direction (direction wedge)


================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

")



(provide :spar_msgs/FlightMotionGoal "830b68dc04cce4ae8cd0b0280e7dd30a")


