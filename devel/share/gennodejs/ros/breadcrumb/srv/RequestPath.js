// Auto-generated. Do not edit!

// (in-package breadcrumb.srv)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let geometry_msgs = _finder('geometry_msgs');

//-----------------------------------------------------------


//-----------------------------------------------------------

class RequestPathRequest {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.start = null;
      this.end = null;
    }
    else {
      if (initObj.hasOwnProperty('start')) {
        this.start = initObj.start
      }
      else {
        this.start = new geometry_msgs.msg.Point();
      }
      if (initObj.hasOwnProperty('end')) {
        this.end = initObj.end
      }
      else {
        this.end = new geometry_msgs.msg.Point();
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type RequestPathRequest
    // Serialize message field [start]
    bufferOffset = geometry_msgs.msg.Point.serialize(obj.start, buffer, bufferOffset);
    // Serialize message field [end]
    bufferOffset = geometry_msgs.msg.Point.serialize(obj.end, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type RequestPathRequest
    let len;
    let data = new RequestPathRequest(null);
    // Deserialize message field [start]
    data.start = geometry_msgs.msg.Point.deserialize(buffer, bufferOffset);
    // Deserialize message field [end]
    data.end = geometry_msgs.msg.Point.deserialize(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 48;
  }

  static datatype() {
    // Returns string type for a service object
    return 'breadcrumb/RequestPathRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'ad6f4eea34a193d38008f1d4053cce66';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    # Calculates a path between two points
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
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new RequestPathRequest(null);
    if (msg.start !== undefined) {
      resolved.start = geometry_msgs.msg.Point.Resolve(msg.start)
    }
    else {
      resolved.start = new geometry_msgs.msg.Point()
    }

    if (msg.end !== undefined) {
      resolved.end = geometry_msgs.msg.Point.Resolve(msg.end)
    }
    else {
      resolved.end = new geometry_msgs.msg.Point()
    }

    return resolved;
    }
};

class RequestPathResponse {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.path = null;
      this.path_sparse = null;
    }
    else {
      if (initObj.hasOwnProperty('path')) {
        this.path = initObj.path
      }
      else {
        this.path = new geometry_msgs.msg.PoseArray();
      }
      if (initObj.hasOwnProperty('path_sparse')) {
        this.path_sparse = initObj.path_sparse
      }
      else {
        this.path_sparse = new geometry_msgs.msg.PoseArray();
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type RequestPathResponse
    // Serialize message field [path]
    bufferOffset = geometry_msgs.msg.PoseArray.serialize(obj.path, buffer, bufferOffset);
    // Serialize message field [path_sparse]
    bufferOffset = geometry_msgs.msg.PoseArray.serialize(obj.path_sparse, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type RequestPathResponse
    let len;
    let data = new RequestPathResponse(null);
    // Deserialize message field [path]
    data.path = geometry_msgs.msg.PoseArray.deserialize(buffer, bufferOffset);
    // Deserialize message field [path_sparse]
    data.path_sparse = geometry_msgs.msg.PoseArray.deserialize(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += geometry_msgs.msg.PoseArray.getMessageSize(object.path);
    length += geometry_msgs.msg.PoseArray.getMessageSize(object.path_sparse);
    return length;
  }

  static datatype() {
    // Returns string type for a service object
    return 'breadcrumb/RequestPathResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'ce73eaa73efb05398295fe135230d380';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    
    # Response:
    #   path:
    #     - List of poses returned in the grid's parent frame
    #     - Oriented facing towards the next point
    #     - Empty if no path was found
    #   path_sparse:
    #     - List of poses returned in the grid's parent frame
    #     - Oriented facing towards the next point
    #     - Empty if no path was found
    #     - Acts the same as "path" but removes intermediate steps if they form a straight line
    
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
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new RequestPathResponse(null);
    if (msg.path !== undefined) {
      resolved.path = geometry_msgs.msg.PoseArray.Resolve(msg.path)
    }
    else {
      resolved.path = new geometry_msgs.msg.PoseArray()
    }

    if (msg.path_sparse !== undefined) {
      resolved.path_sparse = geometry_msgs.msg.PoseArray.Resolve(msg.path_sparse)
    }
    else {
      resolved.path_sparse = new geometry_msgs.msg.PoseArray()
    }

    return resolved;
    }
};

module.exports = {
  Request: RequestPathRequest,
  Response: RequestPathResponse,
  md5sum() { return '01fd153fe570128ee975daa9976a93a4'; },
  datatype() { return 'breadcrumb/RequestPath'; }
};
