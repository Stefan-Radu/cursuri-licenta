
import numpy as np
from numpy.fft import fft
import matplotlib.pyplot as plt
from scipy.interpolate import make_interp_spline


def sine(amp, freq, phase, time):
  return amp * np.sin(2 * np.pi * freq * time + phase)


def rectangular_window(n):
  return np.array([1] * n)

def hanning_window(n):
  return 0.5 * (1 - np.cos(2 * np.pi * np.array(range(n)) / n))


def apply_window(n, window, signal):
  padding = (len(signal) - n) // 2
  return np.concatenate(([0] * padding,
      signal[padding: padding + n] * window(n_w),
      [0] * padding), axis=None)

def apply_window2(window, signal):
  return signal[:n_w] * window(n_w)

############## Exercitiul 2 a #########################

amplitude = 1
freq = 100 #Hz
phase = 0

time_of_view = 0.2 #s
sample_freq = 2000 #Hz

n_samples = int(time_of_view * sample_freq)
n_w = 200

time = np.linspace(0, time_of_view, n_samples)
signal = sine(amplitude, freq, phase, time)
r_signal = apply_window(n_w, rectangular_window, signal)
h_signal = apply_window(n_w, hanning_window, signal)


fig, (ax1, ax2, ax3) = plt.subplots(3, dpi=180)
fig.tight_layout()

ax1.plot(time, signal)
ax1.title.set_text("Sinusoida")
ax2.plot(time, r_signal)
ax2.title.set_text("Rectangular")
ax3.plot(time, h_signal)
ax3.title.set_text("Hanning")
plt.show()

# ############## Exercitiul 2 b #########################

amplitude = 1
freq1 = 1000 #Hz
freq2 = 1100 #Hz
phase = 0

time_of_view = 0.25 #s
sample_freq = 8000 #Hz
n_samples = int(time_of_view * sample_freq)
n_w = 1000

time = np.linspace(0, time_of_view, n_samples)
signal1 = sine(amplitude, freq1, phase, time)
signal2 = sine(amplitude, freq2, phase, time)

r_signal1 = apply_window2(rectangular_window, signal1)
r_signal2 = apply_window2(rectangular_window, signal2)

spectre_r1 = np.abs(fft(r_signal1))
spectre_r2 = np.abs(fft(r_signal2))

fig, (ax1, ax2) = plt.subplots(2, dpi=180)
fig.tight_layout()
ax1.plot(time[:n_samples // 4], spectre_r1[:n_samples // 4])
ax1.plot(time[:n_samples // 4], spectre_r1[:n_samples // 4])
ax1.title.set_text("Pentru 1000Hz")
ax2.plot(time[:n_samples // 4], spectre_r2[:n_samples // 4])
ax2.title.set_text("Pentru 1100Hz")
ax1.grid("True")
ax2.grid("True")
plt.show()

# ############## Exercitiul 2 c #########################

def hamming_window(n):
  return 0.54 - 0.46 * np.cos(2 * np.pi * np.array(range(n)) / n)

def blackman_window(n):
  return 0.42 - 0.5 * np.cos(2 * np.pi * np.array(range(n)) / n) + \
    0.08 * np.cos((4 * np.pi * np.array(range(n)) / n))

def flat_top_window(n):
  return 0.22 - 0.42 * np.cos(2 * np.pi * np.array(range(n)) / n) + \
    0.28 * np.cos(4 * np.pi * np.array(range(n)) / n) - \
    0.08 * np.cos((6 * np.pi * np.array(range(n)) / n)) + \
    0.007 * np.cos((8 * np.pi * np.array(range(n)) / n))


amplitude = 1
freq = 100 #Hz
phase = 0

time_of_view = 0.3 #s
sample_freq = 2000 #Hz

n_samples = int(time_of_view * sample_freq)
n_w = 500

time = np.linspace(0, time_of_view, n_samples)
signal = sine(amplitude, freq, phase, time)
h_signal = apply_window(n_w, hamming_window, signal)
b_signal = apply_window(n_w, blackman_window, signal)
ft_signal = apply_window(n_w, flat_top_window, signal)

fig, (ax1, ax2, ax3, ax4) = plt.subplots(4, dpi=180)
fig.tight_layout()

ax1.plot(time, signal)
ax1.title.set_text("Sinusoida")
ax2.plot(time, h_signal)
ax2.title.set_text("Hamming")
ax3.plot(time, b_signal)
ax3.title.set_text("Blackman")
ax4.plot(time, ft_signal)
ax4.title.set_text("Flat Top")
plt.show()

############## Exercitiul 3 #########################

n_samples = 24 * 3

samples = []
with open("./trafic.csv", "r") as f:
  lines = f.readlines()
  samples = np.array([int(x[:-1]) for x in lines[1:n_samples+1]])

widths = [1, 5, 13, 21]

fig, ax = plt.subplots(len(widths), dpi=180)
fig.tight_layout()


for i, w in enumerate(widths):
  graph = np.convolve(samples, np.ones(w), 'valid') / w

  # netezire
  time = np.linspace(0, n_samples - w + 1, n_samples - w + 1)
  x_y_spline = make_interp_spline(time, graph)
  denser_time = np.linspace(time.min(), time.max(), 500)

  ax[i].plot(denser_time, x_y_spline(denser_time))
  ax[i].title.set_text(f"Latime {w}")

plt.show()
