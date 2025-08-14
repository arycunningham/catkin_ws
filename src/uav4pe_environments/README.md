# uav4pe_environments
Environments package for the UAV4PE Framework to plan UAV Autonomous Mission for Planetary Exploration

<!-- 
## Simulation Installation (steps on clean Ubuntu 20.04):

First we install ROS Noetic:
```
# ROS install
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update
sudo apt install ros-noetic-desktop -y
```

Then we need some ROS package management tools:

```
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
sudo rosdep init
rosdep update
```

Then we create the 

```
#-- make catkin_ws
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
# -> the bashrc need to be source with the ros/devel environment first 
source /opt/ros/noetic/setup.bash
catkin_make

#--Intall QUTUAS
wstool init src
cd ~/catkin_ws/
QFS_PACKAGE=qfs_noetic
curl https://raw.githubusercontent.com/qutas/info/master/Stack/$QFS_PACKAGE.rosinstall > /tmp/$QFS_PACKAGE.rosinstall
wstool merge -t src /tmp/$QFS_PACKAGE.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src -r -y
catkin_make
source ~/catkin_ws/devel/setup.bash
sudo apt install ros-noetic-mavros ros-noetic-mavros-extras -y
roscat mavros install_geographiclib_datasets.sh | sudo bash
mkdir -p ~/catkin_ws/launch
roscp qutas_lab_450 px4_flight_control.launch ~/catkin_ws/launch/control.launch
roscp mavros px4_pluginlists.yaml ./
roscp mavros px4_config.yaml ./
sudo apt-get install ros-noetic-vrpn-client-ros

# -- install planetexp navigation code
cd ~/catkin_ws/src
git clone https://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@github.com/dennisbrar/planetexp_navigation
cd ~/catkin_ws/
catkin_make

#-- PX4 repo cloning:
cd ~/
git clone https://github.com/PX4/PX4-Autopilot.git --recursive
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh
cd ~/PX4-Autopilot
make px4_sitl gazebo

#-- install QgroundControl
sudo usermod -a -G dialout $USER
sudo apt-get remove modemmanager -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
cd ~/Desktop/
wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage
chmod +x ./QGroundControl.AppImage
./QGroundControl.AppImage

# -- Add source devel and setup disros to bashrc
code ~/catkin_ws/launch/control.launch
#<arg name="fcu_url" default="udp://:14540@127.0.0.1:14557" /> to conect with gazebo simulator.
#Change failsafe parameter in QGroundControl:
#COM_RCL_EXEPT to 4 or include offboard mode.

# -- Clone and install (check repos readme) other repos in ~/catkin_ws/src:
cd ~/catkin_ws/src
# https://github.com/Piaktipik/planetExp_sim
git clone git@github.com:Piaktipik/planetExp_sim.git
git clone git@github.com:Piaktipik/planetExp_vision.git


# install extra tools:
# Tmux
sudo apt-get install tmux
# to enable mouse click control add "set -g mouse on" (without quotes) to .tmux.conf in ~/
code ~/.tmux.conf
``` -->