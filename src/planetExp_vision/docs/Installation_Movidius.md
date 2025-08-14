# Installation Instructions of Intel Myriad VPU (or Movidius Neural Compute Stick (NCS))<!-- omit in toc -->

## Table of Contents<!-- omit in toc -->

- [OpenVINO Toolkit Installation](#openvino-toolkit-installation)
  - [Core Components (**Last Updated: 2020-11-21**)](#core-components-last-updated-2020-11-21)
  - [Environment Variables](#environment-variables)
  - [Configure the Neural Compute Stick USB Driver](#configure-the-neural-compute-stick-usb-driver)
  - [Verify Installation](#verify-installation)
- [Creation of Virtual Python Environment for OpenVINO OpenCV](#creation-of-virtual-python-environment-for-openvino-opencv)
- [Edit the Python Interpreter Path from the Demo Script](#edit-the-python-interpreter-path-from-the-demo-script)

## OpenVINO Toolkit Installation

### Core Components (**Last Updated: 2020-11-21**)

**Source:** <https://docs.openvinotoolkit.org/2021.1/openvino_docs_install_guides_installing_openvino_apt.html>

OpenVINO toolkit offers an optimised version of OpenCV for any of their intel hardware (including Intel NCS).

Open a terminal and follow the instructions below:

1. Download the public key from https://apt.repos.intel.com/openvino/2021/GPG-PUB-KEY-INTEL-OPENVINO-2021 and save it to a file.

    ```sh
    curl -o intel_key https://apt.repos.intel.com/openvino/2021/GPG-PUB-KEY-INTEL-OPENVINO-2021
    ```

2. Add this key to the system keyring:

    ```sh
    sudo apt-key add intel_key
    ```

3. Add the APT repository

    ```sh
    echo "deb https://apt.repos.intel.com/openvino/2021 all main" | sudo tee /etc/apt/sources.list.d/intel-openvino-2021.list
    ```

4. Update the list of packages and install the toolkit:

   **Ubuntu 18.04.X LTS**

    ```sh
    sudo apt update
    sudo apt install intel-openvino-dev-ubuntu18-2021.1.110 intel-openvino-runtime-ubuntu18-2021.1.110
    ```

    **Ubuntu 20.04.X LTS**

    ```sh
    sudo apt update
    sudo apt install intel-openvino-dev-ubuntu20-2021.1.110 intel-openvino-runtime-ubuntu20-2021.1.110
    ```

### Environment Variables

Source and append the following environment variables in your bash profile (`~/.bashrc`). They should be invoked **every time** the OpenVINO toolkit and the Intel NCS are used in a terminal.

```sh
function activate {
    if [[ $@ == "openvino" ]]; then
        export OPENVINO_PATH=/opt/intel/openvino_2021
        source $OPENVINO_PATH/bin/setupvars.sh
    else
        command activate "$@"
    fi
}
```

Save changes and close the file. Then, resource the profile and execute the openvino activation commands.

```sh
source $HOME/.bashrc
activate openvino
```

You should see `[setupvars.sh] OpenVINO environment initialized` on the terminal.

### Configure the Neural Compute Stick USB Driver

Configure the USB driver using the following commands:

```sh
cd $OPENVINO_PATH/install_dependencies
./install_NCS_udev_rules.sh
```

Add the current Linux user to the `users` group:

```sh
sudo usermod -a -G users "$(whoami)"
```

Log out and log in for it to take effect.

To perform inference on an Intel Myriad Device (e.g. Intel® Movidius™ Neural Compute Stick and Intel® Neural Compute Stick 2), install the USB rules as follows:

```sh
sudo cp $OPENVINO_PATH/inference_engine/external/97-myriad-usbboot.rules /etc/udev/rules.d/

sudo udevadm control --reload-rules

sudo udevadm trigger

sudo ldconfig
```

### Verify Installation

Run the following scripts to verify a successful installation and device operation in your system.

```sh
cd $OPENVINO_PATH/deployment_tools/model_optimizer/install_prerequisites/
./install_prerequisites.sh
cd $OPENVINO_PATH/deployment_tools/demo
./demo_squeezenet_download_convert_run.sh -d MYRIAD
```

You should get successful demo execution outputs from the terminal.

## Creation of Virtual Python Environment for OpenVINO OpenCV

Install the following packages in your system

```sh
sudo apt install python-virtualenv
```

Then, create a virtual environment called `intelncs` and source it

```sh
virtualenv -p python3.6 ~/.virtualenvs/intelncs
source ~/.virtualenvs/intelncs/bin/activate
```

If the environment is correctly installed and sourced, you should see the name of the environment in brackets. Now, install the required ROS packages for the environment:

```sh
pip install rosinstall rospkg catkin_pkg imutils numpy pyros_setup cython nose mock==1.0.1 pyzmq tblib pytest-timeout click
```

Create a symbolic link to use the optimised OpenVINO OpenCV in the virtual environment

```sh
cd $HOME/.virtualenvs/intelncs/lib/python3.6/site-packages
ln -s $OPENVINO_PATH/python/python3/cv2.abi3.so cv2.so
```

Test the symbolic link by opening the python interpreter and invoking OpenCV

```sh
python -c "import cv2; print(cv2.__version__)"
```

The output should be `4.5.0-openvino`. The displayed version of OpenCV indicates that it is an OpenVINO optimised install!

Deactivate the virtual environment to finish the setup.

```sh
deactivate
```

## Edit the Python Interpreter Path from the Demo Script

Please note that this step is **critical** to perform inference on the system. Open the `openvino_target_detection.py` Python script and update the first line as follows:

1. Target the package directory and open `openvino_target_detection.py`.

    ```sh
    roscd planetexp_vision
    gedit scripts/deepnets_movidius/openvino_target_detection.py
    ```

2. In line 1, change the name of the home user **`jdsandinom`** from `#!/home/jdsandinom/.virtualenvs/intelncs/bin/python` with the name of your local user and save changes.

    ```python
    #!/home/jdsandinom/.pythonenvs/intelncs/bin/python

    """[summary]
    NOTE: Update the path of your virtual environment at line 1 before
    running the script.
    .
    .
    .
    ```

Now, you can follow building instructions from [here](../README.md#installation).
