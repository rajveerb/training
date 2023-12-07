# Check if torch and torchvision installed, if not installed proceed else uninstall first
conda init bash
source /root/.bashrc 
conda create -y -n instrumentation_env python=3.8
conda init bash
# Below is to activate instrumentation_env inside this script. 
# Skipping this command leads to CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'. 
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate instrumentation_env

# Build pytorch v1.10.0
pushd /workspace
git clone https://github.com/rajveerb/pytorch.git
cd pytorch/
git checkout remotes/origin/v1.10.0_extended
pip install setuptools==59.5.0
# Check if correct setuptools version
pip list
conda install -y astunparse numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing_extensions future six requests dataclasses
conda install -y -c pytorch magma-cuda110
git submodule sync
git submodule update --init --recursive --jobs 0
# Below command can cause issues
export CMAKE_PREFIX_PATH=$(dirname $(dirname $(which conda)))
echo "CMAKE_PREFIX_PATH is set to $CMAKE_PREFIX_PATH, it should be set to dir which contains the conda installation"  
python setup.py develop
# Check if installed correctly
conda list
popd

# Build torchvision v0.2.2
pushd /workspace
cd ..
git clone https://github.com/rajveerb/vision.git
cd ./vision/
git checkout remotes/origin/v0.2.2_extended
python setup.py install
#  Check if torchvision installed
pip list
popd

pushd /workspace/
cd ./object_detection/pytorch
python setup.py clean build develop --user
# Check if maskrcnn is installed
pip list
popd

pushd /workspace/object_detection/
pip install -r requirements.txt
pip install --no-cache-dir https://github.com/mlperf/logging/archive/9ea0afa.zip

# check custom_build.log if torch, torchvision and maskrcnn-benchmark installed correctly
pip list | grep "torch" | grep "1.10" >> custom_build.log
pip list | grep "torchvision" | grep "0.2.2" >> custom_build.log
pip list | grep "maskrcnn-benchmark" >> custom_build.log
popd