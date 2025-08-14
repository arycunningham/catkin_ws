# move to environment
openvino
cd ~/catkin_ws/src/planetExp_vision/models/oakd_models

# Conversion parameters:
inputFile='output_exp_1'
meanValues="[123.675, 116.28 , 103.53]"
scaleValues="[58.395, 57.12 , 57.375]"
modelHeight=192
modelWidth=256

# Start from the ONNX
python3 /opt/intel/openvino_2021/deployment_tools/model_optimizer/mo_onnx.py \
    --input_model  "$inputFile.onnx" \
    --input_shape "[1,3,$modelHeight,$modelWidth]"   \
    --mean_values="$meanValues" \
    --scale_values="$scaleValues" \
    --data_type FP16
