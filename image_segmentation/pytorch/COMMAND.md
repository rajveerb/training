bash run_and_time.sh 1
conda create -n instrumentation_env python=3.8
conda init bash
source /root/.bashrc 
conda activate instrumentation_env
cd ..
git clone https://github.com/rajveerb/pytorch.git
cd pytorch/
git checkout remotes/origin/v2.0.0_instrumentation
conda install cmake ninja
pip install -r requirements.txt
conda install mkl mkl-include
git submodule sync
git submodule update --init --recursive
# Below command can cause issues
export CMAKE_PREFIX_PATH=$(dirname $(dirname $(which conda)))
echo "CMAKE_PREFIX_PATH is set to $CMAKE_PREFIX_PATH, it should be set to dir which contains the conda installation"  
apt install g++
python setup.py develop
# Check if installed correctly
conda list

cd ..
git clone https://github.com/rajveerb/vision.git
cd ./vision/
git checkout remotes/origin/v0.15_instrumentation
python setup.py install

cd ../unet3d/
pip install --disable-pip-version-check -r requirements.txt
conda install -c conda-forge libjpeg-turbo
apt-get install libjpeg9
bash run_and_time.sh 1
bash run_and_time.sh 1 LOG