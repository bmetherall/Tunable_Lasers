import numpy as np
import scipy.special.lambertw as W
import matplotlib.pyplot as plt
import time

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
	return np.exp(-T**2 / 2) * A
	#return 1.0 / 2.0 * (1 - nu * np.cos(mu * np.pi * np.exp(-T**2))) * A
	#return 1.0 / 2.0 * (np.cos(np.pi * T) + 1) * (T < 1) * (T > -1) * A

def Fibre(A, f = 10):
	return np.exp(1j * f * A * np.conj(A)) * A

def Disp(A, T, s = 0.1):
	F = np.fft.fft(A)
	dw = np.pi / T[-1]
	w = np.fft.fftfreq(len(A)) * len(A) * dw
	return np.fft.ifft(F * np.exp(1j * w**2 * s**2))

# 1 round trip
def Loop(A, T, dx, s):
	#A = Gain(A, Energy(A, dx))
	#A = Fibre(A, 0)
	#A = Loss(A, 0.5)
	A = Disp(A, T, s)
	A = Mod(A, T)
	return A

N = 100 # Number of loops of the circuit
p = 2**12 # Number of points in the discretization
width = 4 # Size of window
E0 = 1 # Initial energy

# Initialization
T = np.linspace(-width, width, p, endpoint = False)
dx = T[1] - T[0]
A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
E = np.zeros(N)
data = np.zeros((2 * N, p))
A = A0
'''
# Things for animated plot
plt.ion()
fig = plt.figure()
ax = fig.add_subplot(111)
line1, = ax.plot(T, np.real(A), 'r-', label = 'Real')
line2, = ax.plot(T, np.imag(A), 'b-', label = 'Imaginary')
line3, = ax.plot(T, np.abs(A), 'g-', label = 'Magnitude')

fig.canvas.draw()
fig.canvas.flush_events()

plt.legend()
plt.xlim(-2, 2)
plt.ylim(-1, 1)

# N round trips of the laser
for i in range(N):
	# Animate the plot
	line1.set_ydata(np.real(A))
	line2.set_ydata(np.imag(A))
	line3.set_ydata(np.abs(A))
	fig.canvas.draw()
	fig.canvas.flush_events()
	#time.sleep(2)

	A = Loop(A, T, dx, 0.2)
	data[2*i] = np.real(A)
	data[2*i+1] = np.imag(A)
	E[i] = Energy(A, dx)
	print E[i]

steps = np.zeros((12, p))

steps[0] = np.real(A)
steps[1] = np.imag(A)
A = Gain(A, Energy(A, dx))
steps[2] = np.real(A)
steps[3] = np.imag(A)
A = Fibre(A, 0.5)
steps[4] = np.real(A)
steps[5] = np.imag(A)
A = Loss(A, 0.5)
steps[6] = np.real(A)
steps[7] = np.imag(A)
A = Disp(A, T)
steps[8] = np.real(A)
steps[9] = np.imag(A)
A = Mod(A, T)
steps[10] = np.real(A)
steps[11] = np.imag(A)

np.savetxt('Steps.dat', np.vstack((T, steps)).T)


#np.savetxt('Steady.dat', (np.vstack((T, data[-2:], data[-2]**2 + data[-1]**2))).T)

'''

n = 200
data = np.zeros(n)
s = np.linspace(0, 0.8, num = n)

for j in range(n):
	A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
	A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
	A = A0
	for i in range(100):
		old = np.abs(A[len(A)/2])
		A = Loop(A, T, dx, s[j])
		new = np.abs(A[len(A)/2])
		data[j] = new / old


np.savetxt('sdata.dat', np.vstack((s, data)).T)
#plt.plot(s, data)
#plt.show()





