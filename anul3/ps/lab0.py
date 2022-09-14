import numpy as np
import matplotlib.pyplot as plt


def sine(amp, freq, phase, time):
  return amp * np.sin(2 * np.pi * freq * time + phase)


amplitude = 1
frequency = 2 #Hz
phase = np.pi / 2
# phase = 0

time_of_view = 1 #s

n_samples = 15


atime = np.linspace(0, time_of_view, int(1e5))
time = np.linspace(0, time_of_view, n_samples)

asignal = sine(amplitude, frequency, phase, atime)
signal = sine(amplitude, frequency, phase, time)

fig = plt.figure()
plt.plot(atime, asignal)
plt.grid("True")
plt.stem(time, signal)
plt.show()
