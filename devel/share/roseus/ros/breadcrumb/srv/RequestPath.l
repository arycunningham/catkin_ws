;; Auto-generated. Do not edit!


(when (boundp 'breadcrumb::RequestPath)
  (if (not (find-package "BREADCRUMB"))
    (make-package "BREADCRUMB"))
  (shadow 'RequestPath (find-package "BREADCRUMB")))
(unless (find-package "BREADCRUMB::REQUESTPATH")
  (make-package "BREADCRUMB::REQUESTPATH"))
(unless (find-package "BREADCRUMB::REQUESTPATHREQUEST")
  (make-package "BREADCRUMB::REQUESTPATHREQUEST"))
(unless (find-package "BREADCRUMB::REQUESTPATHRESPONSE")
  (make-package "BREADCRUMB::REQUESTPATHRESPONSE"))

(in-package "ROS")

(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass breadcrumb::RequestPathRequest
  :super ros::object
  :slots (_start _end ))

(defmethod breadcrumb::RequestPathRequest
  (:init
   (&key
    ((:start __start) (instance geometry_msgs::Point :init))
    ((:end __end) (instance geometry_msgs::Point :init))
    )
   (send-super :init)
   (setq _start __start)
   (setq _end __end)
   self)
  (:start
   (&rest __start)
   (if (keywordp (car __start))
       (send* _start __start)
     (progn
       (if __start (setq _start (car __start)))
       _start)))
  (:end
   (&rest __end)
   (if (keywordp (car __end))
       (send* _end __end)
     (progn
       (if __end (setq _end (car __end)))
       _end)))
  (:serialization-length
   ()
   (+
    ;; geometry_msgs/Point _start
    (send _start :serialization-length)
    ;; geometry_msgs/Point _end
    (send _end :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; geometry_msgs/Point _start
       (send _start :serialize s)
     ;; geometry_msgs/Point _end
       (send _end :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; geometry_msgs/Point _start
     (send _start :deserialize buf ptr-) (incf ptr- (send _start :serialization-length))
   ;; geometry_msgs/Point _end
     (send _end :deserialize buf ptr-) (incf ptr- (send _end :serialization-length))
   ;;
   self)
  )

(defclass breadcrumb::RequestPathResponse
  :super ros::object
  :slots (_path _path_sparse ))

(defmethod breadcrumb::RequestPathResponse
  (:init
   (&key
    ((:path __path) (instance geometry_msgs::PoseArray :init))
    ((:path_sparse __path_sparse) (instance geometry_msgs::PoseArray :init))
    )
   (send-super :init)
   (setq _path __path)
   (setq _path_sparse __path_sparse)
   self)
  (:path
   (&rest __path)
   (if (keywordp (car __path))
       (send* _path __path)
     (progn
       (if __path (setq _path (car __path)))
       _path)))
  (:path_sparse
   (&rest __path_sparse)
   (if (keywordp (car __path_sparse))
       (send* _path_sparse __path_sparse)
     (progn
       (if __path_sparse (setq _path_sparse (car __path_sparse)))
       _path_sparse)))
  (:serialization-length
   ()
   (+
    ;; geometry_msgs/PoseArray _path
    (send _path :serialization-length)
    ;; geometry_msgs/PoseArray _path_sparse
    (send _path_sparse :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; geometry_msgs/PoseArray _path
       (send _path :serialize s)
     ;; geometry_msgs/PoseArray _path_sparse
       (send _path_sparse :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; geometry_msgs/PoseArray _path
     (send _path :deserialize buf ptr-) (incf ptr- (send _path :serialization-length))
   ;; geometry_msgs/PoseArray _path_sparse
     (send _path_sparse :deserialize buf ptr-) (incf ptr- (send _path_sparse :serialization-length))
   ;;
   self)
  )

(defclass breadcrumb::RequestPath
  :super ros::object
  :slots ())

(setf (get breadcrumb::RequestPath :md5sum-) "01fd153fe570128ee975daa9976a93a4")
(setf (get breadcrumb::RequestPath :datatype-) "breadcrumb/RequestPath")
(setf (get breadcrumb::RequestPath :request) breadcrumb::RequestPathRequest)
(setf (get breadcrumb::RequestPath :response) breadcrumb::RequestPathResponse)

(defmethod breadcrumb::RequestPathRequest
  (:response () (instance breadcrumb::RequestPathResponse :init)))

(setf (get breadcrumb::RequestPathRequest :md5sum-) "01fd153fe570128ee975daa9976a93a4")
(setf (get breadcrumb::RequestPathRequest :datatype-) "breadcrumb/RequestPathRequest")
(setf (get breadcrumb::RequestPathRequest :definition-)
      "# Calculates a path between two points
# Request:
#   start:
#     - Starting point on the grid (in meters)
#     - Z value is ignored
#     - In the grids parent frame
#   end:
#     - Ending point on the grid (in meters)
#     - Z value is ignored
#     - In the grids parent frame

geometry_msgs/Point start
geometry_msgs/Point end


================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z
---

# Response:
#   path:
#     - List of poses returned in the grid's parent frame
#     - Oriented facing towards the next point
#     - Empty if no path was found
#   path_sparse:
#     - List of poses returned in the grid's parent frame
#     - Oriented facing towards the next point
#     - Empty if no path was found
#     - Acts the same as \"path\" but removes intermediate steps if they form a straight line

geometry_msgs/PoseArray path
geometry_msgs/PoseArray path_sparse


================================================================================
MSG: geometry_msgs/PoseArray
# An array of poses with a header for global reference.

Header header

Pose[] poses

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w
")

(setf (get breadcrumb::RequestPathResponse :md5sum-) "01fd153fe570128ee975daa9976a93a4")
(setf (get breadcrumb::RequestPathResponse :datatype-) "breadcrumb/RequestPathResponse")
(setf (get breadcrumb::RequestPathResponse :definition-)
      "# Calculates a path between two points
# Request:
#   start:
#     - Starting point on the grid (in meters)
#     - Z value is ignored
#     - In the grids parent frame
#   end:
#     - Ending point on the grid (in meters)
#     - Z value is ignored
#     - In the grids parent frame

geometry_msgs/Point start
geometry_msgs/Point end


================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z
---

# Response:
#   path:
#     - List of poses returned in the grid's parent frame
#     - Oriented facing towards the next point
#     - Empty if no path was found
#   path_sparse:
#     - List of poses returned in the grid's parent frame
#     - Oriented facing towards the next point
#     - Empty if no path was found
#     - Acts the same as \"path\" but removes intermediate steps if they form a straight line

geometry_msgs/PoseArray path
geometry_msgs/PoseArray path_sparse


================================================================================
MSG: geometry_msgs/PoseArray
# An array of poses with a header for global reference.

Header header

Pose[] poses

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w
")



(provide :breadcrumb/RequestPath "01fd153fe570128ee975daa9976a93a4")


