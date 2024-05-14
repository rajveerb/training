from PIL import Image
import time,itt
from torchvision import transforms
from maskrcnn_benchmark.data.datasets import Load, COCODataset
from maskrcnn_benchmark.config import cfg
from maskrcnn_benchmark.data.transforms import Resize
# increase PIL image open size
Image.MAX_IMAGE_PIXELS = 1000000000

dataset = COCODataset(ann_file="./P3Map/OtherPreOps_data.json",
    root="./P3Map", 
    remove_images_without_annotations=True, 
    transforms=transforms.Compose([]),) # This does not really matter )


id = 0

instances = [0 for _ in range(5)]

for i,id in enumerate(instances):
    # create a Load object
    load = Load(coco_dataset_obj=dataset)
    resize = Resize(min_size=cfg.INPUT.MIN_SIZE_TRAIN, max_size=cfg.INPUT.MAX_SIZE_TRAIN)
    # Load the image and prep for target
    data = load(id)
    # sleep for 1 sec
    time.sleep(1)
    if i == 4:
        itt.resume()
    data = resize(data)
    if i == 4:
        itt.detach()