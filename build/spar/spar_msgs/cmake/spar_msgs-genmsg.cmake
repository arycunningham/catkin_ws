# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "spar_msgs: 7 messages, 0 services")

set(MSG_I_FLAGS "-Ispar_msgs:/home/cdrone/catkin_ws/devel/share/spar_msgs/msg;-Iactionlib_msgs:/opt/ros/noetic/share/actionlib_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(spar_msgs_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg" NAME_WE)
add_custom_target(_spar_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "spar_msgs" "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg" "actionlib_msgs/GoalStatus:spar_msgs/FlightMotionActionFeedback:geometry_msgs/Point:spar_msgs/FlightMotionResult:spar_msgs/FlightMotionActionResult:spar_msgs/FlightMotionGoal:spar_msgs/FlightMotionFeedback:spar_msgs/FlightMotionActionGoal:actionlib_msgs/GoalID:std_msgs/Header"
)

get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg" NAME_WE)
add_custom_target(_spar_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "spar_msgs" "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg" "geometry_msgs/Point:actionlib_msgs/GoalID:std_msgs/Header:spar_msgs/FlightMotionGoal"
)

get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg" NAME_WE)
add_custom_target(_spar_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "spar_msgs" "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg" "actionlib_msgs/GoalStatus:geometry_msgs/Point:spar_msgs/FlightMotionResult:actionlib_msgs/GoalID:std_msgs/Header"
)

get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg" NAME_WE)
add_custom_target(_spar_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "spar_msgs" "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg" "actionlib_msgs/GoalStatus:geometry_msgs/Point:spar_msgs/FlightMotionFeedback:actionlib_msgs/GoalID:std_msgs/Header"
)

get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg" NAME_WE)
add_custom_target(_spar_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "spar_msgs" "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg" "geometry_msgs/Point"
)

get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg" NAME_WE)
add_custom_target(_spar_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "spar_msgs" "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg" "geometry_msgs/Point"
)

get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg" NAME_WE)
add_custom_target(_spar_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "spar_msgs" "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg" "geometry_msgs/Point"
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
)
_generate_msg_cpp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
)
_generate_msg_cpp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
)
_generate_msg_cpp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
)
_generate_msg_cpp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
)
_generate_msg_cpp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
)
_generate_msg_cpp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
)

### Generating Services

### Generating Module File
_generate_module_cpp(spar_msgs
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(spar_msgs_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(spar_msgs_generate_messages spar_msgs_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_cpp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_cpp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_cpp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_cpp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_cpp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_cpp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_cpp _spar_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(spar_msgs_gencpp)
add_dependencies(spar_msgs_gencpp spar_msgs_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS spar_msgs_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
)
_generate_msg_eus(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
)
_generate_msg_eus(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
)
_generate_msg_eus(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
)
_generate_msg_eus(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
)
_generate_msg_eus(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
)
_generate_msg_eus(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
)

### Generating Services

### Generating Module File
_generate_module_eus(spar_msgs
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(spar_msgs_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(spar_msgs_generate_messages spar_msgs_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_eus _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_eus _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_eus _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_eus _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_eus _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_eus _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_eus _spar_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(spar_msgs_geneus)
add_dependencies(spar_msgs_geneus spar_msgs_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS spar_msgs_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
)
_generate_msg_lisp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
)
_generate_msg_lisp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
)
_generate_msg_lisp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
)
_generate_msg_lisp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
)
_generate_msg_lisp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
)
_generate_msg_lisp(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
)

### Generating Services

### Generating Module File
_generate_module_lisp(spar_msgs
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(spar_msgs_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(spar_msgs_generate_messages spar_msgs_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_lisp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_lisp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_lisp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_lisp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_lisp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_lisp _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_lisp _spar_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(spar_msgs_genlisp)
add_dependencies(spar_msgs_genlisp spar_msgs_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS spar_msgs_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
)
_generate_msg_nodejs(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
)
_generate_msg_nodejs(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
)
_generate_msg_nodejs(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
)
_generate_msg_nodejs(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
)
_generate_msg_nodejs(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
)
_generate_msg_nodejs(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
)

### Generating Services

### Generating Module File
_generate_module_nodejs(spar_msgs
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(spar_msgs_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(spar_msgs_generate_messages spar_msgs_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_nodejs _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_nodejs _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_nodejs _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_nodejs _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_nodejs _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_nodejs _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_nodejs _spar_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(spar_msgs_gennodejs)
add_dependencies(spar_msgs_gennodejs spar_msgs_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS spar_msgs_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
)
_generate_msg_py(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
)
_generate_msg_py(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
)
_generate_msg_py(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalStatus.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg;/opt/ros/noetic/share/actionlib_msgs/cmake/../msg/GoalID.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
)
_generate_msg_py(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
)
_generate_msg_py(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
)
_generate_msg_py(spar_msgs
  "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
)

### Generating Services

### Generating Module File
_generate_module_py(spar_msgs
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(spar_msgs_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(spar_msgs_generate_messages spar_msgs_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionAction.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_py _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_py _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_py _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionActionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_py _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionGoal.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_py _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionResult.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_py _spar_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/cdrone/catkin_ws/devel/share/spar_msgs/msg/FlightMotionFeedback.msg" NAME_WE)
add_dependencies(spar_msgs_generate_messages_py _spar_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(spar_msgs_genpy)
add_dependencies(spar_msgs_genpy spar_msgs_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS spar_msgs_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/spar_msgs
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET actionlib_msgs_generate_messages_cpp)
  add_dependencies(spar_msgs_generate_messages_cpp actionlib_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(spar_msgs_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/spar_msgs
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET actionlib_msgs_generate_messages_eus)
  add_dependencies(spar_msgs_generate_messages_eus actionlib_msgs_generate_messages_eus)
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(spar_msgs_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/spar_msgs
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET actionlib_msgs_generate_messages_lisp)
  add_dependencies(spar_msgs_generate_messages_lisp actionlib_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(spar_msgs_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/spar_msgs
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET actionlib_msgs_generate_messages_nodejs)
  add_dependencies(spar_msgs_generate_messages_nodejs actionlib_msgs_generate_messages_nodejs)
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(spar_msgs_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/spar_msgs
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET actionlib_msgs_generate_messages_py)
  add_dependencies(spar_msgs_generate_messages_py actionlib_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(spar_msgs_generate_messages_py geometry_msgs_generate_messages_py)
endif()
