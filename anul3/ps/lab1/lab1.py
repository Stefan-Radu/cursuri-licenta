import numpy as np
import matplotlib.pyplot as plt


############## ex 3 ##############

def sine(amp, freq, phase, time):
  return amp * np.sin(2 * np.pi * freq * time + phase)

amplitude = 1
f_0x, f_0y, f_0z = 260, 140, 60 # frecventele celor 3 semnale
ph_x, ph_y, ph_z = np.pi / 3, -np.pi / 3, np.pi / 3
time_of_view = 0.02 # observam timp de 3 secunde
sample_rate = 200 # Hz / samples per second
no_samples = time_of_view * sample_rate


ctime = np.linspace(0, time_of_view, int(1e5)) # continuu

signal_x = sine(amplitude, f_0x, ph_x, ctime)
signal_y = sine(amplitude, f_0y, ph_y, ctime)
signal_z = sine(amplitude, f_0z, ph_z, ctime)

dtime = np.linspace(0, time_of_view, int(no_samples)) # discret
dsignal_x = sine(amplitude, f_0x, ph_x, dtime)
dsignal_y = sine(amplitude, f_0y, ph_y, dtime)
dsignal_z = sine(amplitude, f_0z, ph_z, dtime)

# plotting
fig, (ax1, ax2, ax3) = plt.subplots(3, dpi=180)
fig.tight_layout()

ax1.set_title("Semnal X")
x = ax1.plot(ctime, signal_x, linewidth=2, label='signal X', color='c')
x_marker, x_line, x_baseline =  ax1.stem(dtime, dsignal_x, label='esantionare X')
plt.setp(x_marker, linewidth=2, color=x[-1].get_color())
plt.setp(x_line, linewidth=1, color=x[-1].get_color())
plt.setp(x_baseline, linewidth=1, color='k')

ax2.set_title("Semnal Y")
y = ax2.plot(ctime, signal_y, linewidth=2, label='signal Y', color='m')
y_marker, y_line, y_baseline =  ax2.stem(dtime, dsignal_y, label='esantionare Y')
plt.setp(y_marker, linewidth=2, color=y[-1].get_color())
plt.setp(y_line, linewidth=1, color=y[-1].get_color())
plt.setp(y_baseline, linewidth=1, color='k')

ax3.set_title("Semnal Z")
z = ax3.plot(ctime, signal_z, linewidth=2, label='signal Z', color='g')
z_marker, z_line, z_baseline =  ax3.stem(dtime, dsignal_z, label='esantionare Z')
plt.setp(z_marker, linewidth=2, color=z[-1].get_color())
plt.setp(z_line, linewidth=1, color=z[-1].get_color())
plt.setp(z_baseline, linewidth=1, color='k')

plt.grid("True")
plt.show()

############## ex 5 ##############

# from scipy.io import wavfile
# from scipy import signal
#
# rate, x = wavfile.read('sound.wav')
# f,t,s = signal.spectrogram(x, fs=rate)
# fig = plt.figure()
# plt.pcolormesh(t, f, 10*np.log10(s), shading='gouraud')
# plt.ylabel('Frequency [Hz]')
# plt.xlabel('Time [sec]')
# plt.show()

############## ex 5 implementation ##############

# import numpy as np
# from PIL import Image, ImageOps
#
# # creating an og_image object
# img = Image.open('spectrogram.png')
# img = ImageOps.grayscale(img)
# # img.show()
#
# pixels = np.array(img)
# pixels = np.transpose(pixels)
#
# for i, line in enumerate(pixels):
#   avg = np.average(line)
#   pixels[i] = np.array(list(map(lambda x: 0 if x <= avg * 0.825 else 255, line)))
# pixels = np.transpose(pixels)
#
# img = Image.fromarray(pixels)
# img.show()
# img.save('processed.png')
#
#
# print(np.average(pixels[80]))
