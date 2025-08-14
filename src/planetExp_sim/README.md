# planetExp_sim
Planet Exploration ROS Simulation code.

## Full simulation Installation steps on clean Ubuntu 20.04:
Libraries
```
sudo apt-get install ros-noetic-gazebo-plugins
sudo apt-get install ros-noetic-gazebo-ros
sudo apt-get install ros-noetic-image-proc
```

# Remember include rospaths in .bashrc:
```
# ----------------------------------------------- Planet_Exp_MP helps ----------------------------
source /opt/ros/noetic/setup.bash
source ~/catkin_ws/devel/setup.bash
 
disros() {
  # Setup for distributed ROS
  export ROS_IP="$(hostname -I | cut -d' ' -f1)"
  echo "Identifying as: $ROS_IP"
 
  if [ "$#" -eq 1 ]
  then
    export ROS_MASTER_URI="http://$1:11311"
    echo "Connecting to: $ROS_MASTER_URI"
  fi
}
 
# Start by default with as master
disros
export PX4_DIR="$HOME/PX4-Autopilot"
 
 
#planetExp help functions:
alias gazeboDVP="export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:~/catkin_ws/src/planetExp_sim/models/; export PX4_SITL_WORLD=~/catkin_ws/src/planetExp_sim/worlds/dvp/dvp.world"
alias cd-planet="cd ~/catkin_ws/src/planetExp_mission_planner/src/problems/planetexp/"
 
## Gazebo ENV VARs
export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11
export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:$HOME/catkin_ws/src/planetExp_sim/models
export GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:$HOME/catkin_ws/src/planetExp_sim/worlds
export LB_MODEL_PATH=${LB_MODEL_PATH}:$HOME/catkin_ws/devel/lib
 
## PX4 ENV VARs
source $PX4_DIR/Tools/setup_gazebo.bash $PX4_DIR $PX4_DIR/build/px4_sitl_default >~/.source_px4.log
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:$PX4_DIR:$PX4_DIR/Tools/sitl_gazebo
export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:$PX4_DIR/build/px4_sitl_default/build_gazebo
 
# Activate console
function l-planet (){
    echo "Starting Tmux session for Planet Exp"
    sleep 2
    tmux new-session -s pexp\; send-keys "roscore" C-m\; split-window -h -p 85\; select-pane -t 0\; split-window -v\;                   \
        send-keys "~/Desktop/./QGroundControl.AppImage" C-m\; select-pane -t 2\; split-window -h\; select-pane -t 2\;                   \
        send-keys "sleep 5; roslaunch planetexp_sim planetExp_simple_load.launch" C-m\; split-window -v -p 75\;               \
        send-keys "sleep 10; roslaunch ~/catkin_ws/launch/control.launch" C-m\; split-window -v -p 60\;                                 \
        send-keys "sleep 5; roslaunch qutas_lab_450 environment.launch" C-m\; split-window -v \;                                        \
        send-keys "sleep 10; rosrun planetexp_vision init_oak_d_vision --hil" \;  select-pane -t 6\;                                   \
        send-keys "rosrun planetexp_nav exp_nav" \;  split-window -v -p 85\;                      \
        send-keys "sleep 10; rosrun planetexp_nav send_input" C-m\; split-window -v -p 80\; select-pane -t 7\; split-window -h\; \
        send-keys "sleep 10; rostopic echo /planetExp/command" C-m\; select-pane -t 9\;                                                 \
        send-keys "roslaunch planetexp_mp planetexp.launch runSimulation:=false" \; split-window -v -p 10\;                             \
        send-keys "tmux kill-session" \;
 
}
export -f l-planet
```
# Launch simulation:
```
roslaunch uas_gazebo_sim uas_demo_load.launch
```
