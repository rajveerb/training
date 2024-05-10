from pytorch_loader import LoadImage
import time,itt
import os

path = os.path.dirname(os.path.abspath(__file__))

image = os.path.join(path, 'case_00165_x.npy')
label = os.path.join(path, 'case_00165_y.npy')

data = {'image': image, 'label': label}
instances = [data for i in range(5)]

for i,image_file in enumerate(instances):
    # sleep for 1 sec
    loader = LoadImage()
    time.sleep(1)
    # convert to RGB like torch's pil_loader
    if i == 4:
        itt.resume()
    data_ = loader(data)
    if i == 4:
        itt.detach()