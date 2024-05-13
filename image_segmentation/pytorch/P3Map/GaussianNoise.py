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

class GaussianNoise:
    def __init__(self, mean, std, prob):
        self.mean = mean
        self.std = std
        self.prob = prob

    def __call__(self, data):
        image = data["image"]
        if random.random() < self.prob:
            scale = np.random.uniform(low=0.0, high=self.std)
            noise = np.random.normal(loc=self.mean, scale=scale, size=image.shape).astype(image.dtype)
            data.update({"image": image + noise})
        return data

for i,data in enumerate(instances):
    # sleep for 1 sec
    loader = LoadImage()
    gn = GaussianNoise(mean=0.0, std=0.1, prob=probability)
    data = loader(data)
    time.sleep(1)
    if i == 4:
        itt.resume()
    data = gn(data)
    if i == 4:
        itt.detach()