set terminal epslatex color size 3.5in,2.15in lw 3 standalone font 10

############################
# 3D plot


load 'BGY.p'
#set format x '%.1f'
#set format y '%.1f'
set format z '%.1f'
set grid
set yl '$T$'
set zl '$|A|$'
set ztics 0.5

set yr [-2.5:2.5]

set xtics ('Loss' 3, 'Disp.' 9, 'Mod.' 15, 'Gain' 21)

set xtics center offset 0,-0.5

set zl offset screen 0.05,0
set yl offset screen 0.1,0

set xyplane 0

set view 45,325,1.25

unset colorbox

set lmargin 6.25

#set out 'Evo.tex'

#set multiplot

set size 1,1.2

#sp 'EBig.dat' u ($2*0.1):1:3 w pm3d not, \
#'Shell1.dat' u 2:1:3 w l lw 0.2 lc 8 not, \
#'Shell2.dat' u ($2*0.1):1:3 w l lw 0.2 lc 8 not

#unset multiplot

#set out


reset

#######################
# Converging

load 'BGY.p'
#set format x '%.1f'
#set format y '%.1f'
set format cb '%.2f'
set grid front
set yl 'Number of Round Trips'
set xl '$T$'
set cbl rotate by 0 '$|A|$'

set cbr [0:1.5]
set xr [-2:2]
set yr [0:36]
set cbtics 0.25
set xtics 1
set ytics 6

set view map
set contour base
set cntrparam levels incremental 0,0.25,1.5

unset cl

#set table 'Contours.dat'
#sp 'Converge.dat' u 1:2:3 w l not
#unset table

set lmargin at screen 0.13
set rmargin at screen 0.79


#set out 'Conv.tex'

#p 'Converge.dat' u 1:2:3 w image not, \
#'Contours.dat' u 1:2 w l lc 8 lw 0.2 not

#set out



reset
#########################
# Breaking

load 'BGY.p'
#set format x '%.1f'
#set format y '%.1f'
set format cb '%.2f'
set grid front
set yl 'Number of Round Trips'
set xl '$T$'
set cbl rotate by 0 '$|A|$'

set cbr [0:1.5]
set xr [-2:2]
set yr [0:36]
set cbtics 0.25
set xtics 1
set ytics 6

set view map
set contour base
set cntrparam levels incremental 0,0.25,1.5

unset cl

#set table 'ContoursBreak.dat'
#sp 'Break.dat' u 1:2:3 w l not
#unset table

set lmargin at screen 0.13
set rmargin at screen 0.79


#set out 'Break.tex'

#p 'Break.dat' u 1:2:3 w image not, \
#'ContoursBreak.dat' u 1:2 w l lc 8 lw 0.2 not
#set out


reset
#################################
# Error plot

load 'BGY.p'

set grid

set xl '$s$'
set yl rotate by 0 '$b$'
set cbl 'Error'

set xtics 0.1
set cbtics 10**4
unset mcbtics
set format x '%.1f'
set format cb '$10^{%01T}$'

set cbr [10**-16:1]

set lmargin at screen 0.12
set rmargin at screen 0.78
set bmargin at screen 0.2


set logscale cb

set view map

#set out 'ParamSpaceErr.tex'
#sp 'Results18.dat' u 1:2:3 w image not
#set out



reset

############################
# Energy plot

load 'BGY.p'

f(x,y) = y < 0.1 ? x : -1

set grid front

set xl '$s$'
set yl rotate by 0 '$b$'
set cbl 'Energy'

set xtics 0.1
set format x '%.1f'
set format cb '%.1f'

set xr [0:0.4]
set yr [0:10]

set lmargin at screen 0.12
set rmargin at screen 0.82
set bmargin at screen 0.2

set view map
unset surface
set contour
set cntrparam levels incremental 0,0.25,3.0

unset cl

set label 1 rotate by -8 '\footnotesize{2.25}' at 0.14, 0.75 front
set label 2 rotate by -10 '\footnotesize{2.00}' at 0.25, 1.2 front
set label 3 rotate by -26 '\footnotesize{1.75}' at 0.25, 3 front
set label 4 rotate by -22.5 '\footnotesize{1.50}' at 0.35, 3.5 front
set label 5 rotate by -45 '\footnotesize{1.25}' at 0.33, 7.3 front
set label 6 rotate by -52.5 '\footnotesize{1.00}' at 0.365, 9.7 front

# This doesnt seem to work for some reason, but it works in the terminal
#set table 'EnergyContours.dat'
#sp 'Results18.dat' u 1:2:(f($5, $3)) w l not
#unset table

#set out 'ParamSpaceEnergy.tex'
#p 'Results18.dat' u 1:2:5 w image not, \
#'EnergyContours.dat' u 1:2 w l lc 8 lw 0.2 not
#set out

reset

############################
# Switched Energy plot

load 'BGY.p'

f(x,y) = y < 0.1 ? x : -1

set grid front

set xl '$s$'
set yl rotate by 0 '$b$'
set cbl 'Energy'

set xtics 0.1
set format x '%.1f'
set format cb '%.1f'

set xr [0:0.4]
set yr [0:10]
set cbr [0:3]

set lmargin at screen 0.12
set rmargin at screen 0.82
set bmargin at screen 0.2

set view map
unset surface
set contour
set cntrparam levels incremental 0,0.25,3.0

unset cl

set label 1 rotate by -14 '\footnotesize{2.25}' at 0.15, 1.12 front
set label 2 rotate by -35 '\footnotesize{2.00}' at 0.265, 3.77 front
#set label 3 rotate by 0 '\footnotesize{1.75}' at 0.25, 3 front

# This doesnt seem to work for some reason, but it works in the terminal
#set table 'EnergyContoursSwitch.dat'
#sp 'ResultsSwitch.dat' u 1:2:(f($5, $3)) w l not
#unset table

#set out 'ParamSpaceEnergySwitch.tex'
#p 'ResultsSwitch.dat' u 1:2:5 w image not, \
#'EnergyContoursSwitch.dat' u 1:2 w l lc 8 lw 0.2 not
#set out

reset

############################
# Example Gaussian

set grid
set xr [-3:3]
set yr [-1:1]

set lmargin at screen 0.14
set rmargin at screen 0.98
set tmargin at screen 0.96

set format y '%.1f'

set key horizontal bottom

set xl '$T / \sigma$'
set yl offset 2 '$A / \sqrt{P}$'

#set xtics (0 0, '$\sigma$' 1, '$2\sigma$' 2, '$-\sigma$' -1, '$-2\sigma$' -2, '$3\sigma$' 3, '-3$\sigma$' -3)

set ytics 0.5

C = 2*sqrt(2)
s = 1.0

spot = sqrt(pi / C) * s

set arrow from 0, 0 to spot, 0 lc rgb 'red'
set label '$\displaystyle \left( \frac{\pi}{C} \right)^{1/2}$' at 0.35 * spot, 0.2 center

set samples 1000

set output './Sample_Gauss.tex'
	p exp(-x**2 / (2*s**2)) t 'Envelope', \
		exp(-x**2 / (2*s**2))*cos(-x**2 * C / (2*s**2)) t 'Real Part' dt 5, \
		exp(-x**2 / (2*s**2))*sin(-x**2 * C / (2*s**2)) t 'Imag. Part' dt 4
set out

## Chirp and Fourier Transform
reset

d(x,y) = (dx=x-x0, x0=x, dy=y-y0, y0=y, (dy > pi) ? (dy = dy-2*pi) : (dy), ((dy < -pi)) ? (dy = dy+2*pi) : (dy), dy/dx)

x0 = NaN
y0 = NaN

set grid
set xr [-2:2]
set yr [-18:18]

set ytics 6
set xtics 1

set xl '$T$'
set yl 'Chirp' offset 1.5

set x2r [-30:30]

set x2l '$\omega - \omega_0$'
set y2l 'Intensity (AU)' offset -2

set x2tics 15
set x2tics border
set y2tics border

set format y2 '$%1.1f$'

set key at 1, 16.5
set key horizontal
set key width -2
set key samplen 3

set lmargin at screen 0.13
set rmargin at screen 0.85

set output 'ChirpFT.tex'
	p 'Features.dat' u 1:(-d($1,$7)) w l t 'Chirp', \
		'Features.dat' u 5:($6 / 12120) w l dt 5 axes x2y2 t 'Intensity'
set out