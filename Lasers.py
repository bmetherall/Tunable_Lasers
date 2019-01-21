##################################################
#			Brady Metherall
#			MSc Thesis
##################################################
'''
This is the code used for my MSc thesis. This code
is separated into four parts each described below.
'''

###############
#	Part I
###############
'''
Function definitions and initialization
'''

import numpy as np
import scipy.special.lambertw as W
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

def func(x, a, b):
	return a * np.exp(-x**2 / (2 * b**2))
 
def Energy(A, dx):
	return np.trapz(np.real(A * np.conj(A)), dx = dx)

# Functions for each component
def Gain(A, E, a = 8000):
	return np.real(np.sqrt(W(a * E * np.exp(E)) / E)) * A

def Loss(A, h = 0.04):
	return h * A

def Mod(A, T):
	return np.exp(-T**2 / 2) * A

def Fibre(A, b = 1.0):
	return np.exp(1j * b * np.abs(A)**2) * A

def Disp(A, T, s = 0.1):
	F = np.fft.fft(A)
	F = F * (np.abs(F) > 10**-4) # Numerical stability
	dw = np.pi / T[-1]
	w = np.fft.fftfreq(len(A)) * len(A) * dw
	return np.fft.ifft(F * np.exp(1j * w**2 * s**2)))

# 1 round trip
def Loop(A, T, dx, s, b, switch = False):
	A = Loss(A)
	if not switch:
		A = Disp(A, T, s)
		A = Mod(A, T)
	else:
		A = Mod(A, T)
		A = Disp(A, T, s)
	A = Gain(A, Energy(A, dx))
	A = Fibre(A, b)
	return A

N = 250 # Number of loops of the circuit
p = 2**12 # Number of points in the discretization
width = 64 # Size of window
E0 = 0.1 # Initial energy

# Initialization
T = np.linspace(-width, width, p, endpoint = False)
dx = T[1] - T[0]
A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
E = np.zeros(N)
data = np.zeros((2 * N, p))
A = A0

part = 4 # Select which part of the code to run

if part == 2:
	###############
	#	Part II
	###############
	'''
	On the fly animation of single realizations
	'''
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
		print i

		A = Loop(A, T, dx, 0.41, 2)
		E[i] = Energy(A, dx)
		#time.sleep(2)

	#np.savetxt('E.dat', E)

	#np.savetxt('Envelope.dat', np.vstack((T, np.abs(A))).T)

elif part == 3:
	###############
	#	Part III
	###############
	'''
	Run the simulation for an nxn grid in s-b space
	'''
	n = 201
	#z = np.zeros((n**2, 4))
	zoom = False

	if zoom:
		s = np.linspace(0, 0.25, num = n)
		#b = np.logspace(3.0, 5.0, num = n)
		b = np.linspace(0, 3, num = n)
	else:
		s = np.linspace(0, 1, num = n)
		#b = np.logspace(3.0, 6.0, num = n)
		b = np.linspace(0, 50, num = n)

	filename = '8000-04-01-DM.dat'
	open(filename, 'w').close()
	f = open(filename, 'ab')

	for k in range(n):
		print k
		z = np.zeros((n, 4))
		for j in range(n):
			A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
			A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
			A = A0
			for i in range(25):
				old = np.abs(A)
				A = Loop(A, T, dx, s[j], b[k], switch = False)
				new = np.abs(A)
			z[j] = s[j], b[k], np.sqrt(np.trapz((old - new)**2, dx = dx)) / np.sqrt(np.trapz(old**2, dx = dx)), Energy(A, dx)
		np.savetxt(f, z)
		f.write('\n')

	f.close()

elif part == 4:
	###############
	#	Part IV
	###############
	'''
	Compute features of linear model (E, P, sigma, C, phi)
	'''
	n = 50
	z = np.zeros((n, 6))
	s = np.linspace(0, 3, num = n)

	for j in range(n):
		A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
		A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
		A = A0
		for i in range(25):
			old = np.angle(A[len(A)/2])
			A = Loop(A, T, dx, s[j], 0, switch = False)
			new = np.angle(A[len(A)/2])
			while old > new:
				old -= 2 * np.pi
		r, sigma = curve_fit(func, T, np.abs(A))[0]
		z[j] = s[j], Energy(A, dx), np.abs(A)[len(A)/2]**2, sigma, -np.gradient(np.gradient(np.angle(A), dx), dx)[len(A)/2] * sigma**2, new - old

	np.savetxt('Linear.dat', z)

else:
	print 'Please enter a valid part number (2--4)'

