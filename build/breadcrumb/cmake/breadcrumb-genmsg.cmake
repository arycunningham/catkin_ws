# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "breadcrumb: 0 messages, 1 services")

set(MSG_I_FLAGS "-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(breadcrumb_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv" NAME_WE)
add_custom_target(_breadcrumb_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "breadcrumb" "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv" "geometry_msgs/Pose:geometry_msgs/PoseArray:geometry_msgs/Point:std_msgs/Header:geometry_msgs/Quaternion"
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(breadcrumb
  "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseArray.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/breadcrumb
)

### Generating Module File
_generate_module_cpp(breadcrumb
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/breadcrumb
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(breadcrumb_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(breadcrumb_generate_messages breadcrumb_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv" NAME_WE)
add_dependencies(breadcrumb_generate_messages_cpp _breadcrumb_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(breadcrumb_gencpp)
add_dependencies(breadcrumb_gencpp breadcrumb_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS breadcrumb_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages

### Generating Services
_generate_srv_eus(breadcrumb
  "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseArray.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/breadcrumb
)

### Generating Module File
_generate_module_eus(breadcrumb
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/breadcrumb
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(breadcrumb_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(breadcrumb_generate_messages breadcrumb_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv" NAME_WE)
add_dependencies(breadcrumb_generate_messages_eus _breadcrumb_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(breadcrumb_geneus)
add_dependencies(breadcrumb_geneus breadcrumb_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS breadcrumb_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(breadcrumb
  "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseArray.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/breadcrumb
)

### Generating Module File
_generate_module_lisp(breadcrumb
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/breadcrumb
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(breadcrumb_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(breadcrumb_generate_messages breadcrumb_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv" NAME_WE)
add_dependencies(breadcrumb_generate_messages_lisp _breadcrumb_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(breadcrumb_genlisp)
add_dependencies(breadcrumb_genlisp breadcrumb_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS breadcrumb_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages

### Generating Services
_generate_srv_nodejs(breadcrumb
  "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseArray.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/breadcrumb
)

### Generating Module File
_generate_module_nodejs(breadcrumb
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/breadcrumb
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(breadcrumb_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(breadcrumb_generate_messages breadcrumb_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv" NAME_WE)
add_dependencies(breadcrumb_generate_messages_nodejs _breadcrumb_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(breadcrumb_gennodejs)
add_dependencies(breadcrumb_gennodejs breadcrumb_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS breadcrumb_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(breadcrumb
  "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/PoseArray.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/breadcrumb
)

### Generating Module File
_generate_module_py(breadcrumb
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/breadcrumb
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(breadcrumb_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(breadcrumb_generate_messages breadcrumb_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/cdrone/catkin_ws/src/breadcrumb/srv/RequestPath.srv" NAME_WE)
add_dependencies(breadcrumb_generate_messages_py _breadcrumb_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(breadcrumb_genpy)
add_dependencies(breadcrumb_genpy breadcrumb_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS breadcrumb_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/breadcrumb)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/breadcrumb
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(breadcrumb_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(breadcrumb_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/breadcrumb)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/breadcrumb
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(breadcrumb_generate_messages_eus std_msgs_generate_messages_eus)
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(breadcrumb_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/breadcrumb)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/breadcrumb
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(breadcrumb_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(breadcrumb_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/breadcrumb)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/breadcrumb
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(breadcrumb_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(breadcrumb_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/breadcrumb)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/breadcrumb\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/breadcrumb
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(breadcrumb_generate_messages_py std_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(breadcrumb_generate_messages_py geometry_msgs_generate_messages_py)
endif()
