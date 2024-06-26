import time,itt
import os
import numpy as np

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

for i,data in enumerate(instances):
    # sleep for 1 sec
    loader = LoadImage()
    time.sleep(1)
    # Load data stored in npy format
    if i == 4:
        itt.resume()
    data = loader(data)
    if i == 4:
        itt.detach()