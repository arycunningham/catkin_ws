// Auto-generated. Do not edit!

// (in-package spar_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let geometry_msgs = _finder('geometry_msgs');

//-----------------------------------------------------------

class FlightMotionGoal {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.motion = null;
      this.position = null;
      this.yaw = null;
      this.velocity_vertical = null;
      this.velocity_horizontal = null;
      this.yawrate = null;
      this.wait_for_convergence = null;
      this.position_radius = null;
      this.yaw_range = null;
    }
    else {
      if (initObj.hasOwnProperty('motion')) {
        this.motion = initObj.motion
      }
      else {
        this.motion = 0;
      }
      if (initObj.hasOwnProperty('position')) {
        this.position = initObj.position
      }
      else {
        this.position = new geometry_msgs.msg.Point();
      }
      if (initObj.hasOwnProperty('yaw')) {
        this.yaw = initObj.yaw
      }
      else {
        this.yaw = 0.0;
      }
      if (initObj.hasOwnProperty('velocity_vertical')) {
        this.velocity_vertical = initObj.velocity_vertical
      }
      else {
        this.velocity_vertical = 0.0;
      }
      if (initObj.hasOwnProperty('velocity_horizontal')) {
        this.velocity_horizontal = initObj.velocity_horizontal
      }
      else {
        this.velocity_horizontal = 0.0;
      }
      if (initObj.hasOwnProperty('yawrate')) {
        this.yawrate = initObj.yawrate
      }
      else {
        this.yawrate = 0.0;
      }
      if (initObj.hasOwnProperty('wait_for_convergence')) {
        this.wait_for_convergence = initObj.wait_for_convergence
      }
      else {
        this.wait_for_convergence = false;
      }
      if (initObj.hasOwnProperty('position_radius')) {
        this.position_radius = initObj.position_radius
      }
      else {
        this.position_radius = 0.0;
      }
      if (initObj.hasOwnProperty('yaw_range')) {
        this.yaw_range = initObj.yaw_range
      }
      else {
        this.yaw_range = 0.0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type FlightMotionGoal
    // Serialize message field [motion]
    bufferOffset = _serializer.uint8(obj.motion, buffer, bufferOffset);
    // Serialize message field [position]
    bufferOffset = geometry_msgs.msg.Point.serialize(obj.position, buffer, bufferOffset);
    // Serialize message field [yaw]
    bufferOffset = _serializer.float32(obj.yaw, buffer, bufferOffset);
    // Serialize message field [velocity_vertical]
    bufferOffset = _serializer.float32(obj.velocity_vertical, buffer, bufferOffset);
    // Serialize message field [velocity_horizontal]
    bufferOffset = _serializer.float32(obj.velocity_horizontal, buffer, bufferOffset);
    // Serialize message field [yawrate]
    bufferOffset = _serializer.float32(obj.yawrate, buffer, bufferOffset);
    // Serialize message field [wait_for_convergence]
    bufferOffset = _serializer.bool(obj.wait_for_convergence, buffer, bufferOffset);
    // Serialize message field [position_radius]
    bufferOffset = _serializer.float32(obj.position_radius, buffer, bufferOffset);
    // Serialize message field [yaw_range]
    bufferOffset = _serializer.float32(obj.yaw_range, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type FlightMotionGoal
    let len;
    let data = new FlightMotionGoal(null);
    // Deserialize message field [motion]
    data.motion = _deserializer.uint8(buffer, bufferOffset);
    // Deserialize message field [position]
    data.position = geometry_msgs.msg.Point.deserialize(buffer, bufferOffset);
    // Deserialize message field [yaw]
    data.yaw = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [velocity_vertical]
    data.velocity_vertical = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [velocity_horizontal]
    data.velocity_horizontal = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [yawrate]
    data.yawrate = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [wait_for_convergence]
    data.wait_for_convergence = _deserializer.bool(buffer, bufferOffset);
    // Deserialize message field [position_radius]
    data.position_radius = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [yaw_range]
    data.yaw_range = _deserializer.float32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 50;
  }

  static datatype() {
    // Returns string type for a message object
    return 'spar_msgs/FlightMotionGoal';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '830b68dc04cce4ae8cd0b0280e7dd30a';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    # ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
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
    # Goal will act as "setpoint" if all velocities are ==0, values of <0 will be rejected
    # If all velocities are ==0, goal will imidiately be finished if not using "wait_for_convergence"
    # For multiple-directional motions (e.g. goto: motion in x/y/z/yaw), the slowest motion will
    # be used to coordinate the motion such that all motions finish at the same point in time
    float32 velocity_vertical			# Speed to ascend and descent
    float32 velocity_horizontal			# Speed to translate
    float32 yawrate						# Speed to rotate
    
    # Convergence information (wait until at location before marking 'complete')
    # If enabled, radius and range values of <=0 will be rejected
    # Note: Landing motions will do not accept "wait_for_convergence", but instead will continue
    #		landing until the action is either cancelled or the UAV is disarmed
    bool wait_for_convergence			# Enable "wait for convergence"
    float32 position_radius				# Positional radius around final location (bubble waypoint)
    float32 yaw_range					# Angular range around final direction (direction wedge)
    
    
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
    const resolved = new FlightMotionGoal(null);
    if (msg.motion !== undefined) {
      resolved.motion = msg.motion;
    }
    else {
      resolved.motion = 0
    }

    if (msg.position !== undefined) {
      resolved.position = geometry_msgs.msg.Point.Resolve(msg.position)
    }
    else {
      resolved.position = new geometry_msgs.msg.Point()
    }

    if (msg.yaw !== undefined) {
      resolved.yaw = msg.yaw;
    }
    else {
      resolved.yaw = 0.0
    }

    if (msg.velocity_vertical !== undefined) {
      resolved.velocity_vertical = msg.velocity_vertical;
    }
    else {
      resolved.velocity_vertical = 0.0
    }

    if (msg.velocity_horizontal !== undefined) {
      resolved.velocity_horizontal = msg.velocity_horizontal;
    }
    else {
      resolved.velocity_horizontal = 0.0
    }

    if (msg.yawrate !== undefined) {
      resolved.yawrate = msg.yawrate;
    }
    else {
      resolved.yawrate = 0.0
    }

    if (msg.wait_for_convergence !== undefined) {
      resolved.wait_for_convergence = msg.wait_for_convergence;
    }
    else {
      resolved.wait_for_convergence = false
    }

    if (msg.position_radius !== undefined) {
      resolved.position_radius = msg.position_radius;
    }
    else {
      resolved.position_radius = 0.0
    }

    if (msg.yaw_range !== undefined) {
      resolved.yaw_range = msg.yaw_range;
    }
    else {
      resolved.yaw_range = 0.0
    }

    return resolved;
    }
};

// Constants for message
FlightMotionGoal.Constants = {
  MOTION_STOP: 0,
  MOTION_GOTO: 1,
  MOTION_GOTO_POS: 2,
  MOTION_GOTO_YAW: 3,
  MOTION_TAKEOFF: 4,
  MOTION_LAND: 5,
}

module.exports = FlightMotionGoal;
