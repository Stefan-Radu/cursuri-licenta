import numpy as np
from numpy.fft import fft
import matplotlib.pyplot as plt
from scipy import signal

def sine(amp, freq, phase, time):
  return amp * np.sin(2 * np.pi * freq * time + phase)


def rectangular_window(n):
  return np.array([0] * n + [1] * n + [0] * n)

def hanning_window(n):
  return np.array([0] * n + \
                  list(0.5 * (1 - np.cos(2 * np.pi * np.array(range(n)) / n))) \
                  + [0] * n)

time_of_view = 1 #s
n_w = 300

time = np.linspace(0, time_of_view, n_w * 3)

# ex 1

rect = rectangular_window(n_w)
hanning = hanning_window(n_w)

fig, (ax1, ax2) = plt.subplots(2, dpi=180)
fig.tight_layout()
ax1.plot(time, rect)
ax2.plot(np.abs(fft(rect))[:n_w * 3 // 2])
ax1.grid("True")
ax2.grid("True")
plt.show()

fig, (ax1, ax2) = plt.subplots(2, dpi=180)
fig.tight_layout()
ax1.plot(time, hanning)
ax2.plot(np.abs(fft(hanning))[:n_w * 3 // 2])
ax1.grid("True")
ax2.grid("True")
plt.show()

##############################################
# ex 2

# citesc traffic data din fisier
data = []
with open('trafic.csv', "r") as f:
  data = [int(x) for x in f.read().split("\n")[1:-1]]

f_s = 1 / 3600 # 1 / h
n = len(data)
freq_space = np.linspace(0, f_s, n)

data = np.array(data)

## a -> afisez traficul si fft-ul

data_fft = np.abs(fft(data))
fig, (ax1, ax2) = plt.subplots(2, dpi=180)
fig.tight_layout()
ax1.plot(data)

## nyquist = f_s / 2 = 1/3600 / 2 = 1 / 7200
nyquist = f_s / 2

ax2.plot(freq_space[1:n // 2], data_fft[1:n // 2])
ax1.grid("True")
ax2.grid("True")
plt.show()

## b

## aleg 3.5 * 10^-5 frecv de taiere, deoarece este un nr rotund
## mai mare decat componentele clar de frecventa ce reies din fft

cutoff_freq = 2.9 * 10 ** -5
w_n = cutoff_freq / nyquist # normalized

def log_scale_filter(h):
  return 20 * np.log10(np.abs(h))

## doar valorile initiale. reapelez la pct f cu alte valori
def solve(N = 5, r_p = 5):
  b1, a1 = signal.butter(N, w_n, btype='low')
  b2, a2 = signal.cheby1(N, r_p, w_n, btype='low')

  ## d

  w_butter, h_butter = signal.freqz(b1, a1)
  w_cheby, h_cheby = signal.freqz(b2, a2)

  fig, (ax1, ax2) = plt.subplots(2, dpi=180)
  fig.tight_layout()
  ax1.plot(w_butter, log_scale_filter(h_butter))
  ax2.plot(w_cheby, log_scale_filter(h_cheby))
  plt.show()

  ## e

  # Butterworth
  butter_sig = signal.filtfilt(b1, a1, data)

  # Chebyshev
  cheby_sig = signal.filtfilt(b2, a2, data)

  fig, (ax1, ax2, ax3) = plt.subplots(3, dpi=180)
  ax1.plot(data)
  ax2.plot(butter_sig)
  ax3.plot(cheby_sig)
  plt.show()

solve()
# As alege filtrul Chebyshev deoarece pastreaza mai bine forma generala a 
# semnalului initial nefiltrat. Butterworth pierde mai mult din detalii

## 2 f
# testez ordine diferite
solve(2)
solve(8)
# ordin mai mare netezeste mai mult

def cheby(r_p1, r_p2):
  b1, a1 = signal.cheby1(5, r_p1, w_n, btype='low')
  b2, a2 = signal.cheby1(5, r_p2, w_n, btype='low')

  # Chebyshev
  cheby_sig1 = signal.filtfilt(b1, a1, data)
  cheby_sig2 = signal.filtfilt(b2, a2, data)

  fig, (ax1, ax2, ax3) = plt.subplots(3, dpi=180)
  fig.tight_layout()
  ax1.plot(data)
  ax2.plot(cheby_sig1)
  ax3.plot(cheby_sig2)
  plt.show()

# compar rp-uri diferite la Chebyshev
cheby(3, 8)
# r_p mai mare netezeste mai mult

# optim (pentru ca pastreaza mai mult din detalii este:
# N = 2, r_p = 3
solve(2, 3)
