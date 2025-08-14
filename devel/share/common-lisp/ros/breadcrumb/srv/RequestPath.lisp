; Auto-generated. Do not edit!


(cl:in-package breadcrumb-srv)


;//! \htmlinclude RequestPath-request.msg.html

(cl:defclass <RequestPath-request> (roslisp-msg-protocol:ros-message)
  ((start
    :reader start
    :initarg :start
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (end
    :reader end
    :initarg :end
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point)))
)

(cl:defclass RequestPath-request (<RequestPath-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <RequestPath-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'RequestPath-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name breadcrumb-srv:<RequestPath-request> is deprecated: use breadcrumb-srv:RequestPath-request instead.")))

(cl:ensure-generic-function 'start-val :lambda-list '(m))
(cl:defmethod start-val ((m <RequestPath-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader breadcrumb-srv:start-val is deprecated.  Use breadcrumb-srv:start instead.")
  (start m))

(cl:ensure-generic-function 'end-val :lambda-list '(m))
(cl:defmethod end-val ((m <RequestPath-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader breadcrumb-srv:end-val is deprecated.  Use breadcrumb-srv:end instead.")
  (end m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <RequestPath-request>) ostream)
  "Serializes a message object of type '<RequestPath-request>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'start) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'end) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <RequestPath-request>) istream)
  "Deserializes a message object of type '<RequestPath-request>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'start) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'end) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<RequestPath-request>)))
  "Returns string type for a service object of type '<RequestPath-request>"
  "breadcrumb/RequestPathRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'RequestPath-request)))
  "Returns string type for a service object of type 'RequestPath-request"
  "breadcrumb/RequestPathRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<RequestPath-request>)))
  "Returns md5sum for a message object of type '<RequestPath-request>"
  "01fd153fe570128ee975daa9976a93a4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'RequestPath-request)))
  "Returns md5sum for a message object of type 'RequestPath-request"
  "01fd153fe570128ee975daa9976a93a4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<RequestPath-request>)))
  "Returns full string definition for message of type '<RequestPath-request>"
  (cl:format cl:nil "# Calculates a path between two points~%# Request:~%#   start:~%#     - Starting point on the grid (in meters)~%#     - Z value is ignored~%#     - In the grids parent frame~%#   end:~%#     - Ending point on the grid (in meters)~%#     - Z value is ignored~%#     - In the grids parent frame~%~%geometry_msgs/Point start~%geometry_msgs/Point end~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'RequestPath-request)))
  "Returns full string definition for message of type 'RequestPath-request"
  (cl:format cl:nil "# Calculates a path between two points~%# Request:~%#   start:~%#     - Starting point on the grid (in meters)~%#     - Z value is ignored~%#     - In the grids parent frame~%#   end:~%#     - Ending point on the grid (in meters)~%#     - Z value is ignored~%#     - In the grids parent frame~%~%geometry_msgs/Point start~%geometry_msgs/Point end~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <RequestPath-request>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'start))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'end))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <RequestPath-request>))
  "Converts a ROS message object to a list"
  (cl:list 'RequestPath-request
    (cl:cons ':start (start msg))
    (cl:cons ':end (end msg))
))
;//! \htmlinclude RequestPath-response.msg.html

(cl:defclass <RequestPath-response> (roslisp-msg-protocol:ros-message)
  ((path
    :reader path
    :initarg :path
    :type geometry_msgs-msg:PoseArray
    :initform (cl:make-instance 'geometry_msgs-msg:PoseArray))
   (path_sparse
    :reader path_sparse
    :initarg :path_sparse
    :type geometry_msgs-msg:PoseArray
    :initform (cl:make-instance 'geometry_msgs-msg:PoseArray)))
)

(cl:defclass RequestPath-response (<RequestPath-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <RequestPath-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'RequestPath-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name breadcrumb-srv:<RequestPath-response> is deprecated: use breadcrumb-srv:RequestPath-response instead.")))

(cl:ensure-generic-function 'path-val :lambda-list '(m))
(cl:defmethod path-val ((m <RequestPath-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader breadcrumb-srv:path-val is deprecated.  Use breadcrumb-srv:path instead.")
  (path m))

(cl:ensure-generic-function 'path_sparse-val :lambda-list '(m))
(cl:defmethod path_sparse-val ((m <RequestPath-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader breadcrumb-srv:path_sparse-val is deprecated.  Use breadcrumb-srv:path_sparse instead.")
  (path_sparse m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <RequestPath-response>) ostream)
  "Serializes a message object of type '<RequestPath-response>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'path) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'path_sparse) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <RequestPath-response>) istream)
  "Deserializes a message object of type '<RequestPath-response>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'path) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'path_sparse) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<RequestPath-response>)))
  "Returns string type for a service object of type '<RequestPath-response>"
  "breadcrumb/RequestPathResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'RequestPath-response)))
  "Returns string type for a service object of type 'RequestPath-response"
  "breadcrumb/RequestPathResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<RequestPath-response>)))
  "Returns md5sum for a message object of type '<RequestPath-response>"
  "01fd153fe570128ee975daa9976a93a4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'RequestPath-response)))
  "Returns md5sum for a message object of type 'RequestPath-response"
  "01fd153fe570128ee975daa9976a93a4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<RequestPath-response>)))
  "Returns full string definition for message of type '<RequestPath-response>"
  (cl:format cl:nil "~%# Response:~%#   path:~%#     - List of poses returned in the grid's parent frame~%#     - Oriented facing towards the next point~%#     - Empty if no path was found~%#   path_sparse:~%#     - List of poses returned in the grid's parent frame~%#     - Oriented facing towards the next point~%#     - Empty if no path was found~%#     - Acts the same as \"path\" but removes intermediate steps if they form a straight line~%~%geometry_msgs/PoseArray path~%geometry_msgs/PoseArray path_sparse~%~%~%================================================================================~%MSG: geometry_msgs/PoseArray~%# An array of poses with a header for global reference.~%~%Header header~%~%Pose[] poses~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'RequestPath-response)))
  "Returns full string definition for message of type 'RequestPath-response"
  (cl:format cl:nil "~%# Response:~%#   path:~%#     - List of poses returned in the grid's parent frame~%#     - Oriented facing towards the next point~%#     - Empty if no path was found~%#   path_sparse:~%#     - List of poses returned in the grid's parent frame~%#     - Oriented facing towards the next point~%#     - Empty if no path was found~%#     - Acts the same as \"path\" but removes intermediate steps if they form a straight line~%~%geometry_msgs/PoseArray path~%geometry_msgs/PoseArray path_sparse~%~%~%================================================================================~%MSG: geometry_msgs/PoseArray~%# An array of poses with a header for global reference.~%~%Header header~%~%Pose[] poses~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <RequestPath-response>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'path))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'path_sparse))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <RequestPath-response>))
  "Converts a ROS message object to a list"
  (cl:list 'RequestPath-response
    (cl:cons ':path (path msg))
    (cl:cons ':path_sparse (path_sparse msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'RequestPath)))
  'RequestPath-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'RequestPath)))
  'RequestPath-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'RequestPath)))
  "Returns string type for a service object of type '<RequestPath>"
  "breadcrumb/RequestPath")