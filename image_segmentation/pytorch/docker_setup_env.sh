# Check if torch and torchvision installed, if not installed proceed else uninstall first
conda init bash
source /root/.bashrc 
conda create -y -n instrumentation_env python=3.8
conda init bash
# Below is to activate instrumentation_env inside this script. 
# Skipping this command leads to CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'. 
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate instrumentation_env

# Build pytorch
pushd /workspace
git clone --depth 1 https://github.com/rajveerb/pytorch.git -b v2.0.0_instrumentation
cd pytorch/
conda install -y cmake ninja
pip install -r requirements.txt
conda install -y mkl mkl-include
git submodule sync
git submodule update --init --recursive --depth 1
# Below command can cause issues
export CMAKE_PREFIX_PATH=$(dirname $(dirname $(which conda)))
echo "CMAKE_PREFIX_PATH is set to $CMAKE_PREFIX_PATH, it should be set to dir which contains the conda installation"  
apt install -y g++
python setup.py develop
# Check if installed correctly
conda list
popd

# Build torchvision
pushd /workspace
git clone --depth 1 https://github.com/rajveerb/vision.git -b v0.15_instrumentation
cd ./vision/
conda install -y -c conda-forge libjpeg-turbo
python setup.py develop
#  Check if torchvision installed
pip list
popd

pushd /workspace/unet3d
pip install --disable-pip-version-check -r requirements.txt

# check custom_build.log if torch, torchvision and maskrcnn-benchmark installed correctly
pip list | grep "torch" | grep "2.0.0a0" >> custom_build.log 
pip list | grep "torchvision" | grep "0.15.1a0" >> custom_build.log
popd