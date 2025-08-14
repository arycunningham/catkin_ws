#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

curl -o ~/openvino_key https://apt.repos.intel.com/openvino/2021/GPG-PUB-KEY-INTEL-OPENVINO-2021
sudo apt-key add ~/openvino_key
echo "deb https://apt.repos.intel.com/openvino/2021 all main" | sudo tee /etc/apt/sources.list.d/intel-openvino-2021.list
sudo apt update
sudo apt install intel-openvino-dev-ubuntu20-2021.3.394 intel-openvino-runtime-ubuntu20-2021.3.394 -y

source ~/.bashrc
export OPENVINO_PATH=/opt/intel/openvino_2021
source $OPENVINO_PATH/bin/setupvars.sh

### Configure the Neural Compute Stick USB Driver
cd $OPENVINO_PATH/install_dependencies
./install_NCS_udev_rules.sh

### Verify Installation
# cd $OPENVINO_PATH/deployment_tools/model_optimizer/install_prerequisites/
# ./install_prerequisites.sh
# cd $OPENVINO_PATH/deployment_tools/demo
# ./demo_squeezenet_download_convert_run.sh -d MYRIAD

### Creation of Virtual Python Environment for OpenVINO OpenCV and DepthAI
# sudo apt install python3-virtualenv
# virtualenv -p python3.8 ~/.virtualenvs/intelncs
# source ~/.virtualenvs/intelncs/bin/activate
# pip install -r ${SCRIPT_DIR}/requirements.txt
# cd $HOME/.virtualenvs/intelncs/lib/python3.8/site-packages/
# ln -s $OPENVINO_PATH/python/python3/cv2.abi3.so cv2.so
# OpenCV_VER="$(python -c "import cv2; print(cv2.__version__)")"
# echo "****************************"
# echo "OpenCV Version: $OpenCV_VER"
# echo "****************************"
# deactivate

 echo "[DONE!]"
