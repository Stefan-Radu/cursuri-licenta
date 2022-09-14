from dictlearn import DictionaryLearning, methods
from matplotlib import image
from sklearn.feature_extraction.image import extract_patches_2d, \
  reconstruct_from_patches_2d
from sklearn.preprocessing import normalize
import numpy as np
from matplotlib import pyplot as plt


p = 8 # dimensiunea unui patch (numar de pixeli)
s = 6 # sparsitatea
N = 1000 # numarul total de patch-uri
n = 256 # numarul de atomi din dictionar
K = 50 # numarul de iteratii DL
sigma = 0.1 # deviatia standard a zgomotului


def psnr(img1, img2):
  mse = np.mean((img1 - img2) ** 2)
  if mse == 0:
    return 0

  max_pixel = 255
  psnr = 20 * np.log10(max_pixel / np.sqrt(mse))
  return round(psnr, 2)


# 1a - load img
img = image.imread("barbara.png")
print(f'img shape: {img.shape}')

# 1b - add noise
img_noisy = img + sigma * np.random.randn(img.shape[0], img.shape[1])

# 1c - extract patches
patch_size = (p, p)
y_noisy = extract_patches_2d(img_noisy, patch_size)
print(f'y_noisy size pre reshape: {y_noisy.shape}')

y_noisy = y_noisy.reshape(y_noisy.shape[0], -1)
print(f'y_noisy size post reshape: {y_noisy.shape}')

# scad media din fiecare linie
mean = np.mean(y_noisy, axis=1)
for i, line in enumerate(y_noisy):
  y_noisy[i] = line - mean[i]

y_noisy = y_noisy.transpose()
print(f'y_noisy size post transpose: {y_noisy.shape}')

# 1d - select n patches
patch_indexes = np.random.choice(y_noisy.shape[1], N)
y = y_noisy[:, patch_indexes]
print(f'y size: {y.shape}')

# 2a - dictionary generation
D0 = np.random.randn(p * p, n)
D0 = normalize(D0, axis=0, norm='max')

# 2b - training
dl = DictionaryLearning(
  n_components=n,
  max_iter=K,
  fit_algorithm='ksvd',
  n_nonzero_coefs=s,
  code_init=None,
  dict_init=D0,
  params=None,
  data_sklearn_compat=False,
)

dl.fit(y)
D = dl.D_

# 3a - sparse representation
x_c, _ = methods.omp(y_noisy, D, n_nonzero_coefs=s)
print(f'x_c size from omp: {x_c.shape}')

# 3b - obtinerea patch-urilor curate
y_c = np.dot(D, x_c)
y_c = y_c.transpose()

print(f'y_c size post transpose: {y_c.shape}')

# adaug media inapoi pe fiecare linie
for i, line in enumerate(y_c):
  y_c[i] = line + mean[i]

# reshape din patch vectorizat in patch 2D
y_c = y_c.reshape(y_c.shape[0], p, p)
print(f'y_c size post reshape: {y_c.shape}')

# 3c - reconstruirea imaginii
img_clean = reconstruct_from_patches_2d(y_c, img.shape)

# 4a&b - vizualizarea imaginilor si a PSNR
plt.figure(figsize=(10, 3), dpi=130)
plt.subplot(131).imshow(img, cmap='gray')
plt.title("Original")

psnr_noisy = psnr(img, img_noisy)
plt.subplot(132).imshow(img_noisy, cmap='gray')
plt.title(f"Noisy (psnr={psnr_noisy})")

psnr_clean = psnr(img_noisy, img_clean)
plt.subplot(133).imshow(img_clean, cmap='gray')
plt.title(f"Denoised (psnr={psnr_clean})")
plt.show()
