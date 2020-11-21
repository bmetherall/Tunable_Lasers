import numpy as np
import matplotlib.pyplot as plt
import time

N = 60
x = np.linspace(-2.5,2.5,20)

z = np.zeros(((4 * N + 1) * 20,3))

plt.ion()
fig = plt.figure()
ax = fig.add_subplot(111)
line1, = ax.plot(x, np.ones(len(x)), 'r-')

fig.canvas.draw()
fig.canvas.flush_events()

plt.xlim(-3, 3)
plt.ylim(0, 1)

t = 0

filename = 'Evolution.dat'
open(filename, 'w').close()
f = open(filename, 'ab')

# Loss
for h in np.linspace(1, 0.5, N, endpoint = False):
	y = 0.907 * h * np.exp(-x**2 / (2 * 0.81))

	line1.set_ydata(y)
	fig.canvas.draw()
	fig.canvas.flush_events()

	z[20*t:20*t+20] = np.vstack((x, t * np.ones(len(x)), y)).T

	np.savetxt(f, np.vstack((x, t * np.ones(len(x)), y)).T)
	f.write('\n\n')
	t += 1

#time.sleep(1)

# Dispersion
for s in np.linspace(0.81, 2.593, N, endpoint = False):
	y = 0.907 * 0.5 * np.sqrt(0.81 / s) * np.exp(-x**2 / (2 * s))

	line1.set_ydata(y)
	fig.canvas.draw()
	fig.canvas.flush_events()

	z[20*t:20*t+20] = np.vstack((x, t * np.ones(len(x)), y)).T

	np.savetxt(f, np.vstack((x, t * np.ones(len(x)), y)).T)
	f.write('\n\n')
	t += 1

#time.sleep(1)

# Modulation
for m in np.linspace(0, 1, N, endpoint = False):
	y = 0.907 * 0.5 * np.sqrt(0.81 / 2.593) * np.exp(-x**2 / (2 * 2.593)) * np.exp(-m * x**2 / 2)

	line1.set_ydata(y)
	fig.canvas.draw()
	fig.canvas.flush_events()

	z[20*t:20*t+20] = np.vstack((x, t * np.ones(len(x)), y)).T

	np.savetxt(f, np.vstack((x, t * np.ones(len(x)), y)).T)
	f.write('\n\n')
	t += 1

#time.sleep(1)

# Gain
for a in np.linspace(1, 3.578, N+1):
	y = a * 0.907 * 0.5 * np.sqrt(0.81 / 2.593) * np.exp(-x**2 / (2 * 2.593)) * np.exp(-x**2 / 2)

	line1.set_ydata(y)
	fig.canvas.draw()
	fig.canvas.flush_events()

	z[20*t:20*t+20] = np.vstack((x, t * np.ones(len(x)), y)).T

	np.savetxt(f, np.vstack((x, t * np.ones(len(x)), y)).T)
	f.write('\n\n')
	t += 1

f.close()

filename = 'Evolution2.dat'
open(filename, 'w').close()
f = open(filename, 'ab')

for i in range(len(x)):
	np.savetxt(f, z[x[i] == z[:,0]])
	f.write('\n\n')

f.close()




