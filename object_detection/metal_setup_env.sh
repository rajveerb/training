# Check if torch and torchvision installed, if not installed proceed else uninstall first
conda create -y -n obj_det_env python=3.8
conda init bash
# Below is to activate instrumentation_env inside this script. 
# Skipping this command leads to CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'. 
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate obj_det_env

echo "Work directory $(pwd)"

# Build pytorch v1.10.0
git clone --depth 1 https://github.com/rajveerb/pytorch.git -b v1.10.0_extended rajveerb_pytorch
pip install setuptools==59.5.0
cd ./rajveerb_pytorch
# Check if correct setuptools version
pip list
conda install -y astunparse numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing_extensions future six requests dataclasses
conda install -y -c pytorch magma-cuda110
git submodule sync
git submodule update --init --recursive --depth 1 --jobs 0
# Below command can cause issues
export CMAKE_PREFIX_PATH=$(dirname $(dirname $(which conda)))
echo "CMAKE_PREFIX_PATH is set to $CMAKE_PREFIX_PATH, it should be set to dir which contains the conda installation"  
python setup.py install
# Check if installed correctly
conda list
cd ..

# Build torchvision v0.2.2
git clone  --depth 1 https://github.com/rajveerb/vision.git -b v0.2.2_extended rajveerb_vision 
cd ./rajveerb_vision
python setup.py install
#  Check if torchvision installed
pip list
cd ..

echo "Current directory $(pwd)"
pip install -r requirements.txt
pip install --no-cache-dir https://github.com/mlperf/logging/archive/9ea0afa.zip

# check custom_build.log if torch, torchvision and maskrcnn-benchmark installed correctly
pip list | grep "torch" | grep "1.10" >> custom_build.log
pip list | grep "torchvision" | grep "0.2.2" >> custom_build.log

# Below allows the user to get debug info for P3Map
sudo apt install -y libjpeg8-dbg