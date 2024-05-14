from PIL import Image
import time,itt
from torchvision import transforms
from maskrcnn_benchmark.data.datasets import Load, COCODataset
from maskrcnn_benchmark.data.transforms import ToTensor
from maskrcnn_benchmark.data.collate_batch import BatchCollator

# increase PIL image open size
Image.MAX_IMAGE_PIXELS = 1000000000


dataset = COCODataset(ann_file="./P3Map/BatchCollator_data.json",
    root="./P3Map", 
    remove_images_without_annotations=True, 
    transforms=transforms.Compose([]),) # This does not really matter )

# Check README to understand the below comment 
# get path of the largest image (1.9 MB) in the dataset is ./pytorch/datasets/coco/train2017/479400.jpg
# id -> 96601
# dataset.ids[id] -> 479400
# file_name = dataset.coco.loadImgs(id)[0]["file_name"] -> 000000479400.jpg
id = 0

runs = 5
# SIZE_DIVISIBILITY can be found in object_detection/pytorch/configs/e2e_mask_rcnn_R_50_FPN_1x.yaml
SIZE_DIVISIBILITY = 32

collator = BatchCollator(size_divisible=SIZE_DIVISIBILITY)
load = Load(coco_dataset_obj=dataset)
convertor = ToTensor()
data = load(id)
img, target = convertor(data)

for i in range(runs):
    batch = [(img, target, id) for _ in range(SIZE_DIVISIBILITY)]
    # sleep for 1 sec
    time.sleep(1)
    if i == 4:
        itt.resume()
    collated_batch = collator(batch)
    if i == 4:
        itt.detach()

    
