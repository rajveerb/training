import time,itt
import os
import numpy as np
import random

path = os.path.dirname(os.path.abspath(__file__))

image = os.path.join(path, 'case_00165_x.npy')
label = os.path.join(path, 'case_00165_y.npy')

data = {'image': image, 'label': label}
instances = [data for i in range(5)]

class LoadImage:
    def __init__(self):
        pass
    def __call__(self,data):
        data = {"image": np.load(data['image']), "label": np.load(data['label'])}
        return data

class Cast:
    def __init__(self, types):
        self.types = types

    def __call__(self, data):
        data["image"] = data["image"].astype(self.types[0])
        data["label"] = data["label"].astype(self.types[1])
        return data

for i,data in enumerate(instances):
    # sleep for 1 sec
    loader = LoadImage()
    cast = Cast(types=(np.float32, np.uint8))
    data = loader(data)
    time.sleep(1)
    if i == 4:
        itt.resume()
    data = cast(data)
    if i == 4:
        itt.detach()