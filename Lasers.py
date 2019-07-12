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
import time
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
	return np.fft.ifft(F * np.exp(1j * w**2 * s**2))

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

N = 25 # Number of loops of the circuit
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

part = 6 # Select which part of the code to run

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

	dw = np.pi / T[-1]
	line3, = ax.plot(T, np.abs(A), 'g-', label = 'Magnitude')

	fig.canvas.draw()
	fig.canvas.flush_events()

	plt.legend()
	plt.xlim(-2, 2)
	plt.ylim(-4, 4)

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

		A = Loop(A, T, dx, 0.15, 0.5)
		E[i] = Energy(A, dx)
		#time.sleep(0.5)

	#np.savetxt('E.dat', E)

	dw = np.pi / T[-1]
	w = np.fft.fftfreq(len(A)) * len(A) * dw

	print np.trapz(T**2 * abs(A), dx = dx) / np.trapz(abs(A), dx = dx)

	#np.savetxt('Linear_Solution.dat', np.vstack((T, np.real(A), np.imag(A), np.abs(A), w, np.abs(np.fft.fft(A)), np.angle(A))).T)

elif part == 3:
	###############
	#	Part III
	###############
	'''
	Run the simulation for an nxn grid in s-b space
	'''
	n = 501
	#z = np.zeros((n**2, 4))
	zoom = True
	step = 1

	if zoom:
		s = np.linspace(0, 0.25, num = n)
		#b = np.logspace(3.0, 5.0, num = n)
		b = np.linspace(0, 3, num = n)
	else:
		s = np.linspace(0, 1, num = n)
		#b = np.logspace(3.0, 6.0, num = n)
		b = np.linspace(0, 50, num = n)

	#filename = 'Step' + str(step) + '.dat'
	filename = 'Step_Big.dat'
	#filename = 'Moments.dat'
	open(filename, 'w').close()
	f = open(filename, 'ab')

	for k in range(n):
		print k
		z = np.zeros((n, 5))
		for j in range(n):
			A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
			A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
			A = A0
#			flag = [0, 0, 0]
#			itera = np.array([100, 100, 100])
#			for i in range(100 / step + 1):
#				old = np.abs(A)
#				for lnum in range(step):
#					A = Loop(A, T, dx, s[j], b[k], switch = False)
#				new = np.abs(A)
#				if (flag[0] == 0) and (np.sqrt(np.trapz((old - new)**2, dx = dx)) < 10**-3): # L2
#					itera[0] = i
#					flag[0] = 1
#				elif (flag[1] == 0) and (np.trapz(np.abs(old - new), dx = dx) < 10**-3): # L1
#					itera[1] = i
#					flag[1] = 1
#				elif (flag[2] == 0) and (np.max(np.abs(old - new)) < 10**-3): # Infinity
#					itera[2] = i
#					flag[2] = 1
#			z[j] = s[j], b[k], itera[0], itera[1], itera[2], np.sqrt(np.trapz((old - new)**2, dx = dx)) / np.sqrt(np.trapz(old**2, dx = dx)), Energy(A, dx)

			for i in range(500):
				A = Loop(A, T, dx, s[j], b[k], switch = False)
			old = np.abs(A)
			A = Loop(A, T, dx, s[j], b[k], switch = False)
			new = np.abs(A)

			err = np.sqrt(np.trapz((new - old)**2, dx = dx) / np.trapz(new**2, dx = dx))
			sigma = np.trapz(T**2 * abs(A), dx = dx) / np.trapz(abs(A), dx = dx)
			kurt = np.trapz(T**4 * abs(A), dx = dx) / np.trapz(T**2 * abs(A), dx = dx)
		
			z[j] = s[j], b[k], sigma, kurt / sigma, err

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

elif part == 5:
	###############
	#	Part V
	###############
	'''
	Compute variance for various b values
	'''
	n = 100
	s = np.linspace(0, 2, num = n)
	b = [0.0, 0.1, 0.5, 1.0, 2.0, 5.0, 10.0]
	m = len(b)
	z = np.zeros((n, m + 1))
	z2 = np.zeros((n, m + 1))
	sigma = np.zeros(m)
	kurt = np.zeros(m)

	for j in range(n):
		A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
		A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
		A = A0
		for k in range(m):
			for i in range(50):
				A = Loop(A, T, dx, s[j], b[k], switch = False)
			old = np.abs(A)
			A = Loop(A, T, dx, s[j], b[k], switch = False)
			new = np.abs(A)
			err = np.sqrt(np.trapz((old - new)**2, dx = dx) / np.trapz(new**2, dx = dx))
			if b[k] == 0 and s[j] < 0.06:
				sigma[k] = 2 * s[j] * (1.0 - s[j])
				kurt[k] = np.nan
			elif err > 0.005:
				sigma[k] = np.nan
				kurt[k] = np.nan
			else:
				sigma[k] = np.trapz(T**2 * abs(A), dx = dx) / np.trapz(abs(A), dx = dx)
				kurt[k] = np.trapz(T**4 * abs(A), dx = dx) / np.trapz(T**2 * abs(A), dx = dx)
		z[j] = np.hstack((s[j], sigma))
		z2[j] = np.hstack((s[j], kurt / sigma))

	np.savetxt('NL_Var.dat', z)
	np.savetxt('NL_Kurt.dat', z2)

elif part == 6:
	###############
	#	Part VI
	###############
	'''
	Compute convergence
	'''
	n = 3
	num_iter = 100
	s = np.linspace(0, 0.225, num = n+1)+0.025
	#b = 5*s
	err = np.zeros((n+1, num_iter))

	print s
	#print b

	for j in range(n+1):
		A0 = 1 / np.cosh(2 * T) * np.exp(1j * np.pi / 4)
		A0 = np.sqrt(E0 / Energy(A0, dx)) * A0 # Normalize
		A = A0
		for i in range(num_iter):
			old = np.abs(A)
			A = Loop(A, T, dx, s[j], 0.5, switch = False)
			new = np.abs(A)
			err[j, i] = np.sqrt(np.trapz((old - new)**2, dx = dx) / np.trapz(new**2, dx = dx))

	np.savetxt('ROC.dat', err.T)

else:
	print 'Please enter a valid part number (2--6)'















