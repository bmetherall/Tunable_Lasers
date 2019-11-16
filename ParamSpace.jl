using FFTW
using LambertW
using PyPlot

function fftfreq(n)
	# Same as np.fft.fftfreq
	w = zeros(n)
	N = trunc(Int32, (n - 1) / 2) + 1
	w[1:N] = 0:N-1
	w[N+1:end] = -trunc(Int32, n / 2):-1
	return w / n
end

# I couldn't find this anywhere surprisingly
function trapz(y, dx)
	s = 0.0
	s += sum(y[2:end-1])
	s += (y[1] + y[end]) / 2.0
	return s * dx
end

function Energy(A, dx)
	return trapz(abs.(A).^2, dx)
end

function Gain(A, E, a = 8000)
	return real(sqrt(lambertw(a * E * exp(E)) / E)) .* A
end

function Loss(A, h = 0.04)
	return h * A
end

function Mod(A, x)
	return exp.(-x.^2 / 2) .* A	
end

function Fibre(A, b = 1.0)
	return exp.(1im * b * abs.(A).^2) .* A
end

function Disp(A, x, s = 0.1)
	F = fft(A)
	F = F .* (abs.(F) .> 10^-12)
	dw = pi / x[end]
	w = fftfreq(length(A)) * length(A) * dw
	return ifft(F .* exp.(1im * w.^2 * s^2))
end

function Loop(A, x, dx, s, b, N = 1)
	for i in 1:N
		A = Loss(A)
		A = Disp(A, x, s)
		A = Mod(A, x)
		A = Gain(A, Energy(A, dx))
		A = Fibre(A, b)
	end
	return A
end



N = 60 # Number of loops of the circuit
p = 2^18 # Number of points in the discretization
width = 8 # Size of window
E0 = 0.1 # Initial energy

# Initialization
x = LinRange(-width, width, p)
dx = x[2] - x[1]
A0 = 1.0 ./ cosh.(2 * x) * exp(1im * pi / 4.0)
A0 = sqrt(E0 / Energy(A0, dx)) * A0 # Normalize

A = A0

A = Loop(A, x, dx, 0.1, 1.59, 30)

plot(x, abs.(A))
plot(x, real.(A))
plot(x, imag.(A))
show()




