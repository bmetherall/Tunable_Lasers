using Distributed
@everywhere using FFTW
@everywhere using LambertW
@everywhere using DelimitedFiles
@everywhere using SharedArrays

@everywhere function fftfreq(n::Int)
	# Same as np.fft.fftfreq
	w = zeros(n)
	N = div((n - 1), 2) + 1
	w[1:N] = 0:N-1
	w[N+1:end] = -div(n, 2):-1
	return w / n
end

# I couldn't find this anywhere surprisingly
@everywhere function trapz(y, dx)::Float64
	s = 0.0
	s += sum(y[2:end-1])
	s += (y[1] + y[end]) / 2.0
	return s * dx
end

@everywhere function Energy(A, dx)
	return trapz(abs2.(A), dx)
end

@everywhere function Gain(A, E, a = 8000)
	return real(sqrt(lambertw(a * E * exp(E)) / E)) .* A
end

@everywhere function Loss(A, h::Float64 = 0.04)
	return h * A
end

@everywhere function Mod(A, x)
	return @. exp(-x^2 / 2) * A
end

@everywhere function Fibre(A, b::Float64 = 1.0)
	return @. exp(1im * b * abs2(A)) * A
end

@everywhere function Disp(A, x, s::Float64 = 0.1, b::Float64 = 1.0)
	F = fft(A)
	dw = pi / x[end]
	w = fftfreq(length(A)) * length(A) * dw

	c = b + 15 * s
	if c >= 6 # Shenanigans
		F = @. F * (abs(F) > 10^(1 + 0.6 * c - 15.6))
	else
		F = @. F * (abs(F) > 10^-11)
	end
	return ifft(@. F * exp(1im * w^2 * s^2))
end

# Complete loop of the cavity
@everywhere function Loop(A, x, dx, s::Float64, b::Float64, N::Int64 = 1)
	for i in 1:N
		A = Loss(A)
		A = Disp(A, x, s, b)
		A = Mod(A, x)
		A = Gain(A, Energy(A, dx))
		A = Fibre(A, b)
	end
	return A
end

@everywhere function LoopSwitch(A, x, dx, s::Float64, b::Float64, N::Int64 = 1)
	for i in 1:N
		A = Loss(A)
		A = Mod(A, x)
		A = Disp(A, x, s, b)
		A = Gain(A, Energy(A, dx))
		A = Fibre(A, b)
	end
	return A
end

# Compute solution on a grid
function Solve(A0, n::Int64, m::Int64, numloops::Int64, fname = "Results.dat")
	"""
	Comptues 2-norm error, Inf-norm error, Energy, Variance, and Kurtosis within the s-b plane.
	"""
	f = open(fname, "w");

	s = LinRange(0.0, 0.4, n)
	b = LinRange(0.0, 10.0, m)

	for k in 1:m # b loop
		println(k)
		z = SharedArray{Float64, 2}((n, 7))
		@sync @distributed for j in 1:n # s loop
			A = A0
			A = Loop(A, x, dx, s[j], b[k], numloops - 1)
			old = abs.(A)
			A = Loop(A, x, dx, s[j], b[k])
			new = abs.(A)

			# Compute quantities
			err2 = sqrt(trapz((new - old).^2, dx) / trapz(abs2.(A), dx))
			errinf = maximum(abs.(new - old))
			sigma = trapz(x.^2 .* new, dx) / trapz(new, dx)
			kurt = trapz(x.^4 .* new, dx) / trapz(x.^2 .* new, dx)
			energy = Energy(new, dx)

			# Build array of values
			z[j,:] = [s[j] b[k] err2 errinf energy sigma kurt / sigma]
		end
		# Write data to file
		writedlm(f, z)
		println(f, "")
	end
	close(f)
end

function energy_plot(A, x, dx, s, b, N)
	res = zeros(N)

	for i in 1:N
		A = Loop(A, x, dx, s, b)
		res[i] = Energy(A, dx)
	end

	display(plot(x, abs.(A)))

	return 1:N, res	
end

# Parameters
p = 2^12 # Number of points in the discretization
width = 8 # Size of window
E0 = 0.1 # Initial energy
n = 151 # Number in s
m = 101 # Number in b
numloops = 25

# Initialization
x = LinRange(-width, width, p)
dx = x[2] - x[1]
A0 = 1.0 ./ cosh.(2 * x) * exp(1im * pi / 4.0)
#A0 = exp.(-(x .- 0.5).^2 ./ (2 * 0.05^2))
A0 = sqrt(E0 / Energy(A0, dx)) * A0 # Normalize

# Loop(A0, x, dx, 0.1, 1.0, 2); # Compile

# Solve(A0, 2, 2, 2) # Compile

# @time Solve(A0, n, m, numloops, "ResultsDelta.dat")
