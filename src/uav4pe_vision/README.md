# uav4pe_vision
uav4pe_vision package part of the UAV4PE framework

This ROS package contains algorithms developed in Python to to detect objects using OAK-D devices.

## Requirements

- Ubuntu 20.04.X
- [uav4pe_environments](https://github.com/qutas/uav4pe_environments) package installed in your workspace 

## Installation

1. Clone this repository into your local catkin workspace.

   ```sh
    cd <path/to/catkin_ws/src>
    git clone https://github.com/qutas/uav4pe_vision
    ```

3. Install depthAI library and depthAI ROS [depthai-ros](https://github.com/luxonis/depthai-ros)
 
   ```sh
    pip3 install depthai
    ```

## Ensure you have cv-bridge and vision-opencv packages installed using aptitude store and install depthai packages using pip

```
sudo apt-get install ros-noetic-compressed-image-transport
sudo apt-get install ros-noetic-camera-info-manager
sudo apt-get install ros-noetic-rqt-image-view
sudo apt-get install ros-noetic-cv-bridge
sudo apt-get install ros-noetic-vision-opencv

sudo apt-get install python3-pip
python3 -m pip install -U depthai
```
