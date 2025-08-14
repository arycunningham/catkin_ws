# Planet Exploration Vision Module

This ROS package contains algorithms to detect objects from OAK-D sensors, and are developed in Python.

The outputs of the vision module are published as ROS topics, and the data inputs (*e.g.*, local position and orientation) are read via subscribed ROS topics.

## Requirements

- A Linux Ubuntu install (tested against **18.04.X** LTS)
- (**IMPORTANT**) A simulation environment (recommended [uas_gazebo_sim](https://gitlab.com/qut-asl-upo/uas_gazebo_sim) package installed in your workspace) or real instance of a camera that publishes ROS topics using the structure `/<camera_namespace>/camera/~`.

## Installation

1. Clone this repository into your local catkin workspace.

   ```sh
    cd <path/to/catkin_ws/src>
    git clone https://github.com/Piaktipik/planetExp_vision.git
    ```

2. Source `autoinstall_dependencies.sh` to use Intel Myriad X VPU Hardware onboard the OAK-D. (Legacy instructions can be found [here](docs/Installation_Movidius.md)).

   ```sh
    source planetexp_vision/setup/autoinstall_dependencies.sh
   ```

3. Clone [uas_gazebo_sim](https://gitlab.com/qut-asl-upo/uas_gazebo_sim) if testing the system under simulation (and follow its installation instructions),

    ```sh
    git clone https://gitlab.com/qut-asl-upo/uas_gazebo_sim
    ```

4. Build the workspace:

    ```sh
    catkin build -DCMAKE_BUILD_TYPE=Release
    ```

5. If using Myriad X VPU, you need to log out and log in again to apply policy changes and access the hardware.

## Getting Started

### OAK-D Streamer (ROS)
<!-- 
1. Connect (if not already connected) your OAK-D camera the host machine (local machine or companion computer).
2. Open a terminal and source the catkin workspace if it is not sourced by default.

    ```sh
    source <path/to/catkin_ws>/devel/setup.bash
    ```

3. Run the streamer script:

    ```sh
    source $(rospack find planetexp_vision)/scripts/init_oak_d_streamer
    ```

4. You can verify advertised frames using `rostopic find` or `rviz`. -->


1. Connect (if not already connected) your OAK-D camera to the host machine (local machine or companion computer).
2. Source your catkin workspace and advertise your ROS camera topics by running a simulation instance in Gazebo:

    ```sh
    source /path/to/catkin_ws/devel/setup.bash
    roslaunch uas_gazebo_sim uas_demo_load.launch camera_name:=oak_d_RGB
    ```

3. Run the demo using any of the following options:

    ```sh
    rosrun planetexp_vision init_oak_d_vision <args>
    ```

    For example, to run the node in a local machine to enable hardware in the loop (HIL) between the OAK-D for onboard inference of CNN models, and Gazebo:

    ```sh
    rosrun planetexp_vision init_oak_d_vision --hil
    ```

    If you want to run the node onboard a companion computer (*e.g., Raspberry Pi*) for HIL with Gazebo running in a local machine, obtain the *ROS MASTER URI* I.P. address of the local machine.
    Then, execute the following in the companion computer:

    ```sh
    rosrun planetexp_vision init_oak_d_vision --hil --uri <LOCAL_MACHINE_ROS_MASTER_URI>
    ```

## Camera Class

The scripts use a custom Python class called `GenericCamera`.
This class allows the estimation of target location using camera properties and robot pose as arguments.
Please revise the camera properties to obtain accurate results.

### Camera Parameters

- Focal Length (in millimetres).
- Sensor Width (in millimetres).
- Sensor Height (in millimetres).
- Width Resolution (in pixels).
- Height Resolution (in pixels).
- Offset in X (in metres).
- Offset in Y (in metres).
- Offset in Z (in metres).
- Gimbal angle (in **degrees**).

## Changelog

See the [changelog](CHANGELOG.md) for further details.

## Acknowledgements

The development of this software is funded by The Commonwealth Scientific and Industrial Research Organisation (CSIRO) Data61 PhD Scholarships and The Queensland University of Technology (QUT).

## Copyright

Copyright &copy; 2019-2022 Juan Sandino (juan.sandino@hdr.qut.edu.au), The Commonwealth Scientific and Industrial Research Organisation (CSIRO). All rights reserved.

**This software is confidential and cannot not be used, modified or shared unless for the approved specific purposes by the Copyright owners.**
