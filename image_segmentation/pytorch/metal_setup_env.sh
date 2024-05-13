# !/bin/bash
# Check if torch and torchvision installed, if not installed proceed else uninstall first
# Run below commands in the terminal first
conda create -y -n instrumentation_env python=3.8
conda init bash
# Below is to activate instrumentation_env inside this script. 
# Skipping this command leads to CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'. 
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate instrumentation_env

echo "Work directory $(pwd)"

# Build pytorch
git clone --depth 1 https://github.com/rajveerb/pytorch.git -b v2.0.0_instrumentation rajveerb_pytorch
cd rajveerb_pytorch/
conda install -y cmake ninja
pip install -r requirements.txt
conda install -y mkl mkl-include
git submodule sync
git submodule update --init --recursive --depth 1
# Below command can cause issues
export CMAKE_PREFIX_PATH=$(dirname $(dirname $(which conda)))
echo "CMAKE_PREFIX_PATH is set to $CMAKE_PREFIX_PATH, it should be set to dir which contains the conda installation"  
sudo apt install -y g++
python setup.py develop
cd ..

# Build torchvision
git clone --depth 1 https://github.com/rajveerb/vision.git -b v0.15_instrumentation rajveerb_vision
cd rajveerb_vision/
conda install -y -c conda-forge libjpeg-turbo
sudo apt-get install -y libjpeg9
python setup.py develop
cd ..

cd pytorch 
pip install --disable-pip-version-check -r requirements.txt
# check custom_build.log if torch, torchvision and maskrcnn-benchmark installed correctly
pip list | grep "torch" | grep "2.0.0a0" >> custom_build.log 
pip list | grep "torchvision" | grep "0.15.1a0" >> custom_build.log