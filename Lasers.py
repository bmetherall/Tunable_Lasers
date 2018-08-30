import numpy as np
import scipy.special.lambertw as W
import matplotlib.pyplot as plt

def Energy(A, dx):
	return np.real(np.sum(A * np.conj(A)) * dx)

# Functions for each component
def Gain(A, E, a = 30):
	if E < 20:
		return np.sqrt(W(a * E * np.exp(E)) / E) * A
	else:
		# For large E python has overflow problems, but this approximation can be used instead
		return np.sqrt((E + np.log(a)) / E) * A

def Loss(A, h = 0.1):
	return h * A

def Mod(A, T, nu = 1, mu = 1):
	return 1.0 / 2.0 * (1 - nu * np.cos(mu * np.pi * np.exp(-T**2))) * A

def Fibre(A, f = 10):
	return np.exp(1j * f * A * np.conj(A)) * A

def Disp(A, T, s = 0.1):
	F = np.fft.fft(A)
	dw = np.pi / T[-1]
	w = np.fft.fftfreq(len(A)) * len(A) * dw
	return np.fft.ifft(F * np.exp(1j * w**2 * s**2))

# 1 round trip
def Loop(A, T, dx):
	A = Gain(A, Energy(A, dx))
	A = Disp(A, T)
	A = Mod(A, T)
	A = Loss(A, 0.25)
	A = Fibre(A)
	return A

N = 280 # Number of loops of the circuit
p = 2**12 # Number of points in the discretization
width = 4 # Size of window
E0 = 1 # Initial energy

# Initialization
T = np.linspace(-width, width, p, endpoint = False)
dx = T[1] - T[0]
A0 = np.exp(1j * np.pi * 1.0 / 4.0) / np.cosh(5 * T)
A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
E = np.zeros(N)
data = np.zeros((2 * N, p))
A = A0

# Things for animated plot
plt.ion()
fig = plt.figure()
ax = fig.add_subplot(111)
line1, = ax.plot(T, np.real(A), 'r-', label = 'Real')
line2, = ax.plot(T, np.imag(A), 'b-', label = 'Imaginary')
line3, = ax.plot(T, np.abs(A), 'g-', label = 'Magnitude')

plt.legend()
plt.xlim(-2, 2)
plt.ylim(-0.25, 0.25)

# N round trips of the laser
for i in range(N):
	A = Loop(A, T, dx)
	data[2*i] = np.real(A)
	data[2*i+1] = np.imag(A)
	E[i] = Energy(A, dx)

	# Animate the plot
	line1.set_ydata(np.real(A))
	line2.set_ydata(np.imag(A))
	line3.set_ydata(np.abs(A))
	fig.canvas.draw()
	fig.canvas.flush_events()

	#if i == 40:
	#	plt.close()
	#	plt.plot(np.fft.fft(A))
	#	plt.show()
	#	plt.pause(20)

#np.savetxt('Steady.dat', (np.vstack((T, data[-2:], data[-2]**2 + data[-1]**2))).T)

plt.close()

plt.plot(E)
plt.show()

plt.pause(4)




