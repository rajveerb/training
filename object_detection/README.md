# 1. Problem
Object detection and segmentation. Metrics are mask and box mAP.

# 2. Directions

### Steps to configure machine

1. Checkout the MLPerf repository
```
mkdir -p mlperf
cd mlperf
git clone https://github.com/rajveerb/training.git
```
2. Assumes CUDA 11.8, CuDNN 8 and Docker is installed with nvidia support

3. Build the docker image for the object detection task
```
cd training/object_detection/
# below will take a lot of time
docker build . -t mlperf/object_detection
```

### Steps to download data
```
# From training/object_detection/
source download_dataset.sh
```

### Steps to run benchmark.
```
docker run -ti --gpus all --rm --ipc=host  -v ./pytorch/datasets:/workspace/object_detection/pytorch/datasets mlperf/object_detection

# activate conda env
conda activate instrumentation_env
# below command to check if environment is active
conda info | grep "active environment"

cd /workspace/object_detection/pytorch
python setup.py clean build develop --user
# Check if maskrcnn is installed
pip list | grep "maskrcnn-benchmark"

cd /workspace/object_detection
./run_and_time.sh
```

# 3. Dataset/Environment
### Publication/Attribution
Microsoft COCO: Common Objects in Context

### Data preprocessing
Only horizontal flips are allowed.

### Training and test data separation
As provided by MS-COCO (2017 version).

### Training data order
Randomly.

### Test data order
Any order.

# 4. Model
### Publication/Attribution
He, Kaiming, et al. "Mask r-cnn." Computer Vision (ICCV), 2017 IEEE International Conference on.
IEEE, 2017.

We use a version of Mask R-CNN with a ResNet-50 backbone.

### List of layers
Running the timing script will display a list of layers.

### Weight and bias initialization
The ResNet-50 base must be loaded from the provided weights. They may be quantized.

### Loss function
Multi-task loss (classification, box, mask). Described in the Mask R-CNN paper.

Classification: Smooth L1 loss

Box: Log loss for true class.

Mask: per-pixel sigmoid, average binary cross-entropy loss.

### Optimizer
Momentum SGD. Weight decay of 0.0001, momentum of 0.9.

# 5. Quality
### Quality metric
As Mask R-CNN can provide both boxes and masks, we evaluate on both box and mask mAP.

### Quality target
Box mAP of 0.377, mask mAP of 0.339

### Evaluation frequency
Once per epoch, 118k.

### Evaluation thoroughness
Evaluate over the entire validation set. Use the official COCO API to compute mAP.
