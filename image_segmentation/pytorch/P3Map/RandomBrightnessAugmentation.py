import time,itt
import os
import numpy as np
import random

path = os.path.dirname(os.path.abspath(__file__))

image = os.path.join(path, 'case_00165_x.npy')
label = os.path.join(path, 'case_00165_y.npy')

data = {'image': image, 'label': label}
instances = [data for i in range(5)]

probability = 1

class LoadImage:
    def __init__(self):
        pass
    def __call__(self,data):
        data = {"image": np.load(data['image']), "label": np.load(data['label'])}
        return data

class RandomBrightnessAugmentation:
    def __init__(self, factor, prob):
        self.prob = prob
        self.factor = factor

    def __call__(self, data):
        image = data["image"]
        if random.random() < self.prob:
            factor = np.random.uniform(low=1.0-self.factor, high=1.0+self.factor, size=1)
            image = (image * (1 + factor)).astype(image.dtype)
            data.update({"image": image})
        return data

for i,data in enumerate(instances):
    # sleep for 1 sec
    loader = LoadImage()
    rba = RandomBrightnessAugmentation(factor=0.3, prob=probability)
    data = loader(data)
    time.sleep(1)
    if i == 4:
        itt.resume()
    data = rba(data)
    if i == 4:
        itt.detach()