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

class RandFlip:
    def __init__(self, probability=None):
        self.axis = [1, 2, 3]
        self.prob = 1 / len(self.axis) if not probability else probability

    def flip(self, data, axis):
        data["image"] = np.flip(data["image"], axis=axis).copy()
        data["label"] = np.flip(data["label"], axis=axis).copy()
        return data

    def __call__(self, data):
        for axis in self.axis:
            if random.random() < self.prob:
                data = self.flip(data, axis)
        return data


for i,data in enumerate(instances):
    # sleep for 1 sec
    loader = LoadImage()
    rand_flip = RandFlip(probability=probability)
    data = loader(data)
    time.sleep(1)
    if i == 4:
        itt.resume()
    data = rand_flip(data)
    if i == 4:
        itt.detach()