set terminal epslatex color size 8.40cm,5.45cm lw 3 standalone font 9 header '\usepackage{mathpazo}'

############################
# 3D plot

load 'BGY.p'
#set format x '%.1f'
#set format y '%.1f'
set format z '%.1f'
set grid
set xl '$z$' offset screen 0.02,-0.02
set yl '$T$' offset screen 0.02,0
set zl '$|A|$' offset screen 0.05,0
set ztics 0.5 offset 0.5

set yr [-2.5:2.5]

set xtics ('Loss' 3, 'Disp.' 9, 'Mod.' 15, 'Gain' 21)

set xtics center offset 0,-0.5

set xyplane 0

set view 45,325

unset colorbox

#set out 'Evo.tex'

#set multiplot

set lmargin at screen 0.26
set rmargin at screen 0.86
set bmargin at screen 0.30
set tmargin at screen 0.99

#sp '../Data/EBig.dat' u ($2*0.1):1:3 w pm3d not, \
#'../Data/Shell1.dat' u 2:1:3 w l lw 0.2 lc 8 not, \
#'../Data/Shell2.dat' u ($2*0.1):1:3 w l lw 0.2 lc 8 not

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

#p '../Data/Converge.dat' u 1:2:3 w image not, \
#'../Data/Contours.dat' u 1:2 w l lc 8 lw 0.2 not

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

#p '../Data/Break.dat' u 1:2:3 w image not, \
#'../Data/ContoursBreak.dat' u 1:2 w l lc 8 lw 0.2 not

#set out

reset
#################################
# Error plot

load 'BGY.p'

set grid

set xl '$s$'
set yl rotate by 0 '$b$'
set cbl 'Error $(\Delta)$'

set xtics 0.1
set cbtics 10**4
unset mcbtics
set format x '%.1f'
set format cb '$10^{%01T}$'

set cbr [10**-16:1]

set lmargin at screen 0.12
set rmargin at screen 0.78
set bmargin at screen 0.18
set tmargin at screen 0.95

set logscale cb

set view map

#set out 'ParamSpaceErr.tex'

#sp '../Data/Results18.dat' u 1:2:3 w image not

#set out

reset

############################
# Energy plot

load 'BGY.p'

f(x,y) = y < 0.1 ? x : -1

set grid front

set xl '$s$'
set yl rotate by 0 '$b$' offset 1
set cbl 'Energy'

set xtics 0.1
set format x '%.1f'
set format cb '%.1f'

set xr [0:0.4]
set yr [0:10]

set lmargin at screen 0.12
set rmargin at screen 0.82
set bmargin at screen 0.18
set tmargin at screen 0.95

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
# Apparently table formats the contour file based on x-y format
#set table '../Data/EnergyContours.dat'
#sp '../Data/Results18.dat' u 1:2:(f($5, $3)) w l not
#unset table

#set out 'ParamSpaceEnergy.tex'

#p '../Data/Results18.dat' u 1:2:5 w image not, \
#'../Data/EnergyContours.dat' u 1:2 w l lc 8 lw 0.2 not

#set out

reset

############################
# Switched Energy plot

load 'BGY.p'

f(x,y) = y < 0.1 ? x : -1

set grid front

set xl '$s$'
set yl rotate by 0 '$b$' offset 1
set cbl 'Energy'

set xtics 0.1
set format x '%.1f'
set format cb '%.1f'

set xr [0:0.4]
set yr [0:10]
set cbr [0:3]

set lmargin at screen 0.12
set rmargin at screen 0.82
set bmargin at screen 0.18
set tmargin at screen 0.95

set view map
unset surface
set contour
set cntrparam levels incremental 0,0.25,3.0

unset cl

set label 1 rotate by -14 '\footnotesize{2.25}' at 0.15, 1.12 front
set label 2 rotate by -35 '\footnotesize{2.00}' at 0.265, 3.77 front
#set label 3 rotate by 0 '\footnotesize{1.75}' at 0.25, 3 front

# This doesnt seem to work for some reason, but it works in the terminal
# See above
#set table '../Data/EnergyContoursSwitch.dat'
#sp '../Data/ResultsSwitch.dat' u 1:2:(f($5, $3)) w l not
#unset table

#set out 'ParamSpaceEnergySwitch.tex'

#p '../Data/ResultsSwitch.dat' u 1:2:5 w image not, \
#'../Data/EnergyContoursSwitch.dat' u 1:2 w l lc 8 lw 0.2 not

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

#set output './Sample_Gauss.tex'
#	p exp(-x**2 / (2*s**2)) t 'Envelope', \
#		exp(-x**2 / (2*s**2))*cos(-x**2 * C / (2*s**2)) t 'Real Part' dt 5, \
#		exp(-x**2 / (2*s**2))*sin(-x**2 * C / (2*s**2)) t 'Imag. Part' dt 4
#set out

reset

#########################
# Chirp

d(x,y) = (dx=x-x0, x0=x, dy=y-y0, y0=y, (dy > pi) ? (dy = dy-2*pi) : (dy), ((dy < -pi)) ? (dy = dy+2*pi) : (dy), dy/dx)

x0 = NaN
y0 = NaN

set grid
set xr [-2:2]
set yr [-12:12]

set xtics 1
set ytics 4

set key top left

set xl '$T$'
set yl 'Chirp' offset 1,0

set lmargin at screen 0.15
set rmargin at screen 0.98
set tmargin at screen 0.96

#set output 'Chirp.tex'
#	p '../Data/ChirpFT1.dat' u 1:(-d($1,$7)) w l t '$b = 1.0$', \
#	'../Data/ChirpFT4.dat' u 1:(-d($1,$7)) w l dt 5 t '$b = 4.0$'
#set out

reset

#########################
# Fourier Transform

set grid

set xr [-20:20]

set xl '$\omega$'
set yl '$\left| \mathcal{F} \{ A \} \right|$ (AU)' offset 0.5,0

set xtics 10

set key top left

set format y '$%1.1f$'

set lmargin at screen 0.15
set rmargin at screen 0.98
set tmargin at screen 0.96

#set output 'FT.tex'
#	p '../Data/ChirpFT1.dat' u 5:($6 / 4140) w l t '$b=1.0$', \
#		'../Data/ChirpFT4.dat' u 5:($6 / 4140) w l dt 5 t '$b=4.0$'
#set out
