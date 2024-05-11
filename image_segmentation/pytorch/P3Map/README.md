# P3Map


## Preprocessing operations

The following operations are performed in the image segmentation pipeline (found in `image_segmentation/pytorch/data_loading/pytorch_loader.py`):

1. LoadImage
2. RandBalancedCrop
3. RandFlip
4. Cast
5. RandomBrightnessAugmentation
6. GaussianNoise

Note: Below configurations from parser defaults values of the benchmark for `RandBalancedCrop`

```python
input_shape = [128, 128, 128]
oversampling = 0.4
config = {"patch_size": input_shape, "oversampling": oversampling,}
# Since, some operations are performed on the basis of a probability, but for the sake of mapping we set it to 1. 
```

## Steps to get mapping via P3Map

```bash
conda activate instrumentation_env
# Follow instructions in image_segmentation/itt-python/README.md for installing
# Be outside P3Map directory and run below command
bash P3Map/P3Map.sh
# Run the `image_segmentation/pytorch/P3Map/logsToMapping.ipynb`
# Output mapping is stored in `image_segmentation/pytorch/P3Map/mapping_funcs.json`
```

## Finding large element from the `kits19` dataset

```bash
find ../kits19/preprocessed_data/ -type f -printf "%s\t%p\n" | sort -n | tail -1
```

Above should yield `case_00165_x.npy`. We copy the corresponding label to it `case_00165_y.npy`.