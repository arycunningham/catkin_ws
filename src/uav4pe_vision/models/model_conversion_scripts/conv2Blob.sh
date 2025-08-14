# move to environment
#activate openvino
openvino
cd ~/catkin_ws/src/planetExp_vision/models/oakd_models

# Conversion parameters:
inputIRFile='output_exp_1'

# Generate blob #    -ip U8 \ -ip FP16 \
/opt/intel/openvino_2021/deployment_tools/inference_engine/lib/intel64/myriad_compile \
    -m "$inputIRFile.xml" \
    -ip U8 \
    -VPU_NUMBER_OF_SHAVES 6 \
    -VPU_NUMBER_OF_CMX_SLICES 6 \