import numpy as np
import matplotlib.pyplot as plt

images = np.zeros((9, 400, 600))

for i in range(9):
    img = np.load(f"./images/car_{i}.npy")
    images[i] = img


for i in range(9):
    plt.imshow(images[i], cmap='gray')
    plt.show()
