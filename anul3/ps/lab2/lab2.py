import numpy as np
from numpy.fft import fft
import matplotlib.pyplot as plt


def sine(amp, freq, phase, time):
  return amp * np.sin(2 * np.pi * freq * time + phase)


amplitude = 1
freq = 10 #Hz
phase = 0

time_of_view = 1 #s
sample_freq = 1000 #Hz

n_samples = time_of_view * sample_freq

time = np.linspace(0, time_of_view, n_samples)
signal = sine(amplitude, freq, phase, time)

spectre = np.abs(fft(signal))

fig, (ax1, ax2) = plt.subplots(2, dpi=180)
fig.tight_layout()

ax1.plot(time, signal)
ax2.plot(time[:n_samples // 2], spectre[:n_samples // 2])

plt.grid("True")
plt.show()
