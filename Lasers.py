import numpy as np
import scipy.special.lambertw as W
import matplotlib.pyplot as plt
import time

def Energy(A, dx):
	return np.trapz(np.real(A * np.conj(A)), dx = dx)

def zeta(s):
	return np.exp(-0.511444 * s + 0.00174128)

def EE(a, s, h):
	r = zeta(s)**2 * h**2
	return r / (1 - r) * np.log(a * r)

# Functions for each component
def Gain(A, E, a = 8000):
	return np.real(np.sqrt(W(a * E * np.exp(E)) / E)) * A

def Loss(A, h = 0.04):
	return h * A

def Mod(A, T):
	return np.exp(-T**2 / 2) * A

def Fibre(A, b = 0.25):
	return np.exp(1j * b * np.real(np.abs(A)**2)) * A

def Disp(A, T, s = 0.2):
	F = np.fft.fft(A)
	F = (np.abs(F) > 10**-4) * F
	dw = np.pi / T[-1]
	w = np.fft.fftfreq(len(A)) * len(A) * dw
	return np.fft.ifft(F * np.exp(1j * (w**2 * s**2 - 0 * s**2 * w**3)))

# 1 round trip
def Loop(A0, T, dx, s, b):
	A = A0
	A = Gain(A0, Energy(A0, dx))
	#A = Fibre(A, b)
	A = Loss(A)
	#old = np.gradient(-np.gradient(np.angle(A), dx),dx)[len(A)/2]
	A = Disp(A, T, s)
	#new = np.gradient(-np.gradient(np.angle(A), dx),dx)[len(A)/2]
	A = Mod(A, T)
	#print old - new
	return A

N = 50 # Number of loops of the circuit
p = 2**14 # Number of points in the discretization
width = 128 # Size of window
E0 = 0.0001 # Initial energy

# Initialization
T = np.linspace(-width, width, p, endpoint = False)
dx = T[1] - T[0]
#A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
A0 = np.exp(-(1+2.89005*1j)*T**2 / (2*0.938229**2))
A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
E = np.zeros(N)
data = np.zeros((2 * N, p))
A = A0

#######################################

dw = np.pi / T[-1]
w = np.fft.fftfreq(len(A)) * len(A) * dw

# Things for animated plot
plt.ion()
fig = plt.figure()
ax = fig.add_subplot(111)
#line1, = ax.plot(T, np.real(A), 'r-', label = 'Real')
#line2, = ax.plot(T, np.imag(A), 'b-', label = 'Imaginary')
line3, = ax.plot(T, np.angle(A), 'g-', label = 'Magnitude')

fig.canvas.draw()
fig.canvas.flush_events()

plt.legend()
#plt.xlim(-5000, 5000)
#plt.ylim(0, 0.02)

plt.xlim(-4, 4)
plt.ylim(-10, 10)

dw = np.pi / T[-1]
w = np.fft.fftfreq(len(A)) * len(A) * dw

# N round trips of the laser
for i in range(N):
	# Animate the plot
	#line1.set_ydata(np.real(np.fft.fft(A)))
	#line2.set_ydata(np.imag(np.fft.fft(A)))
	#line3.set_ydata(np.abs(np.fft.fft(A)))

	#line1.set_ydata(np.real(A))
	#line2.set_ydata(np.imag(A))
	line3.set_ydata(np.gradient(-np.gradient(np.angle(A), dx), dx))
	fig.canvas.draw()
	fig.canvas.flush_events()
	time.sleep(1)
	#print np.gradient(-np.gradient(np.angle(A), dx), dx)[len(A)/2]

	A = Loop(A, T, dx, 1.0, 0)
	E[i] = Energy(A, dx)

	#np.savetxt('Envelope' + str(i) + '.dat', np.vstack((T, np.real(A), np.imag(A), np.abs(A), np.angle(A), w, np.abs(np.fft.fft(A)))).T)

np.savetxt('E.dat', E)

np.savetxt('Envelope.dat', np.vstack((T, np.real(A), np.imag(A), np.abs(A))).T)
print np.abs(A[len(A)/2])
print np.std(np.abs(A))

############################################
'''
n = 51
z = np.zeros((n**2, 4))
s = np.linspace(0, 1.6, num = n)
b = np.linspace(0, 5, num = n)3
count = 0

for k in range(n):
	for j in range(n):
		A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
		#A0 = np.exp(-T**2 / 2)
		A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
		A = A0
		for i in range(50):
			old = np.abs(A)
			A = Loop(A, T, dx, s[j], b[k])
			new = np.abs(A)
		z[count] = s[j], b[k], np.sqrt(np.trapz((old - new)**2, dx = dx)) / np.sqrt(np.trapz(old**2, dx = dx)), Energy(A, dx)
		count += 1

#np.savetxt('Zeta.dat', np.vstack((s, z)).T)
np.savetxt('a30.dat', z)

'''

