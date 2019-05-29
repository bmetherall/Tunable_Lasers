set terminal epslatex color size 3in,2.7in lw 3

# Chirp
set xr [-3:3]
set grid
set ytics 1
set xtics 2
set samples 10000
set format y '%.1f'

set output './Figures/Unchirped.tex'
p exp(-x**2/2)*sin(3*pi*x) not
set out

set output './Figures/Chirped.tex'
p exp(-x**2/2)*sin(2*(x-pi)**2) not
set out

reset

# Gaussian Series

u(x) = (sgn(x) + 1.0) / 2.0

set xr [-3:3]
set yr [-1.5:4.5]
set grid
set ytics 1
set xtics 2
set samples 10000
set format y '%.1f'
set xl '$x$'
set key bottom right

set output './Figures/GS1.tex'
p '../Gaussian.dat' u 1:2 w l t 'Gaussian Series', \
(x-1)**2 * u(x+1) * u(2-x) dt 5 t '$(x-1)^2 \rect{\frac{2x-1}{6}}$'
set out

set xr [-6:6]
set yr [-2:2]

set output './Figures/GS2.tex'
p '../Gaussian.dat' u 1:3 w l t 'Gaussian Series', \
sin(x) * u(x+pi) * u(pi-x) dt 5 t '$\sin(x) \rect{\frac{x}{2\pi}}$'
set out

set terminal epslatex color size 6in,3.7in lw 3

set xr [-3:3]
set yr [-0.1:1.2]
set ytics 0.2
set xtics 1
set key top right
set key width -20

set output './Figures/GaussMod.tex'
p '../Gaussian2.dat' u 1:2 w l t 'Gaussian Series', \
(1 - cos(pi * exp(-x**2)))/2.0 dt 5 t '$\frac{1}{2} \left( 1 - \cos \left( \pi \exp \left( -x^2 \right) \right) \right)$'
set out

reset

# Errors
set terminal epslatex color size 3in,1.78in lw 3
#set xl '$s$'
#set yl rotate by 0 '$b$'
load '/home/brady/Templates/Blues.p'
set grid front
set cbr [10**-12:1]
set xr [0:0.25]
set yr [0:3]
set view map
set format x ''
set format y ''

set lmargin 1
set rmargin 1
set tmargin 0.5
set bmargin 0.5

unset colorbox

set logscale cb

#set output './Figures/Step2.tex'
#p '../Step2.dat' u 1:2:6 w image not
#set out

#set output './Figures/Step3.tex'
#p '../Step3.dat' u 1:2:6 w image not
#set out

#set output './Figures/Step5.tex'
#p '../Step5.dat' u 1:2:6 w image not
#set out

#set output './Figures/Step7.tex'
#p '../Step7.dat' u 1:2:6 w image not
#set out

#set output './Figures/Step9.tex'
#p '../Step9.dat' u 1:2:6 w image not
#set out

#set output './Figures/Step11.tex'
#p '../Step11.dat' u 1:2:6 w image not
#set out

#set output './Figures/Step13.tex'
#p '../Step13.dat' u 1:2:6 w image not
#set out

#set output './Figures/Step16.tex'
#p '../Step16.dat' u 1:2:6 w image not
#set out

#set output './Figures/Step60.tex'
#p '../Step60.dat' u 1:2:6 w image not
#set out

reset

set terminal epslatex color size 6in,3.7in lw 3
set yr [0:0.4]
set xr [0:0.25]
set key top left
set ytics 0.1
set xl '$s$'
set format y '%.1f'
set format x '%.2f'
set key width -2

set output './Figures/Lim_s_0.tex'
set grid
p '../LinearAnalytic.dat' u 1:($4**2) t 'Analytic Variance' w l, \
2*x - 2*x**2 t '$2 s \left( 1 - s \right)$' dt 5
set out

reset

set xl '$s$'
set yr [0.94:1]
set xr [1.4:3]
set key bottom right
set ytics 0.02
set format y '%.2f'
set format x '%.1f'
set key width -5


set output './Figures/Lim_s_Infty.tex'
set grid
p '../LinearAnalytic.dat' u 1:($4**2) t 'Analytic Variance' w l, \
1 - 1/(4*x**4) + 3/(8*x**8) t '$1 - \frac{1}{4} s^{-4} + \frac{3}{8} s^{-8}$' dt 5
set out


reset

set xl '$x$'
set yr [-4:2]
set xr [-1:5]
set tr [0:]
set key top left

set output './Figures/LambertPlot.tex'
set grid
set parametric
p (t-1)*exp(t-1), t-1 t '$W_0(x)$', (-1-t)*exp(-1-t), -1-t t '$W_{-1}(x)$' dt 5
set out

reset

# Lambert W function
set xl '$x$'
set yr [-4:2]
set xr [-1:5]
set tr [0:]
set key top left

set output './Figures/LambertPlot.tex'
set grid
set parametric
p (t-1)*exp(t-1), t-1 t '$W_0(x)$', (-1-t)*exp(-1-t), -1-t t '$W_{-1}(x)$' dt 5
set out

reset

# Variance
set xl '$s$'
set yr [-0.2:1]
set xr [0:3]
set key bottom left
set format xy '%.1f'

set output './Figures/Variance.tex'
set grid
p '../LinearAnalytic.dat' u 1:($4**2) t 'Analytic Variance' w l, \
'../LinearAnalytic.dat' u 1:5 t 'Analytic Chirp' w l lc 2 dt 5, \
'../LinearAnalytic.dat' u 1:6 t 'Analytic Phase Shift' w l lc 3 dt 4, \
'../Linear.dat' u 1:($4**2) t 'Simulation Variance' pt 7 lc 1, \
'../Linear.dat' u 1:5 t 'Simulation Chirp' pt 7 lc 2, \
'../Linear.dat' u 1:6 t 'Simulation Phase Shift' pt 7 lc 3
set out

reset

# Power and Energy
set xl '$s$'
set yr [0:3]
set xr [0:3]
set key top right
set format xy '%.1f'

set output './Figures/LinearPlot.tex'
set grid
p 2.5 - x not lc 8 lw 0.3, \
'../LinearAnalytic.dat' u 1:2 t 'Analytic Energy' w l lc 1, \
'../LinearAnalytic.dat' u 1:3 t 'Analytic Amplitude' w l lc 2 dt 5, \
'../Linear.dat' u 1:2 t 'Energy' pt 7 lc 1, \
'../Linear.dat' u 1:3 t 'Amplitude' pt 7 lc 2

set out

reset

# Parameter Space
set xl '$s$'
set yl rotate by 0 '$b$'
load '/home/brady/Templates/Blues.p'
set grid front
set view map
set format x '%.1f'

#set cbr [0.1:0.1001]
#unset colorbox

set palette maxcolors 2

set palette defined ( 0 '#F7FBFF',\
    	    	      1 '#084594' )

#set cbtics ('Stable' 0.25, 'Unstable' 0.75)

set cbtics ('' 0.25, '' 0.75)

set cbl rotate by 90 'Stable \hspace{14mm} Unstable'

set output './Figures/Cartoon.tex'
sp '../8000-04-01-DM.dat' u 1:2:($3 < 0.05 ? 0 : 1) w image not lw 0.3
set out

set cbl rotate by 0 '$E$'

set format cb '%.1f'
set cbr [0:3]
unset cl
set contour base
set cntrparam levels incremental 0, 0.25, 3

load '/home/brady/Templates/Blues.p'

#set output './Figures/Stability.tex'
#sp '../8000-04-01-DM.dat' u 1:2:4 w pm3d not lw 0.3
#set out
#
#set output './Figures/StabilitySwitch.tex'
#sp '../8000-04-01-MD.dat' u 1:2:4 w pm3d not lw 0.3
#set out

set format y '%.1f'
set format x '%.2f'

#set output './Figures/StabilityZoom.tex'
#sp '../8000-04-01-DM-Z.dat' u 1:2:4 w pm3d not lw 0.3
#set out
#
#set output './Figures/StabilitySwitchZoom.tex'
#sp '../8000-04-01-MD-Z.dat' u 1:2:4 w pm3d not lw 0.3
#set out

set cbr [0:25]
set cbl rotate by 90 '$bE$'
set format x '%.1f'
unset format cb
unset format y

unset cl
set contour base
set cntrparam levels incremental 0, pi, 140


#set terminal epslatex color size 3in,2.25in lw 3

set terminal epslatex color size 6in,3.7in lw 3

#set output './Figures/EffNL.tex'
#sp '../8000-04-01-DM.dat' u 1:2:($4*$2) w pm3d not lw 0.3
#set out

#unset format cb
#set cbr [5:50]
#set cbl rotate by 90 'Iterations'
#set cntrparam levels incremental 0, 1, 50

#set output './Figures/Iteration.tex'
#sp '../Iteration.dat' u 1:2:3 w pm3d not lw 0.3
#set out

reset

# Error
set xl '$s$'
set yl rotate by 0 '$b$'
set cbl 'Error'
load '/home/brady/Templates/Blues.p'
set grid front
set cbr [10**-12:1]
set xr [0:0.25]
set yr [0:3]
set view map
set format x '%.2f'
set format y '%.1f'
set format cb '$10^{%01T}$'

set logscale cb

#set output './Figures/Step1.tex'
#p '../Step1.dat' u 1:2:6 w image not
#set out

set cbl 'Composite Error'

#set output './Figures/Min.tex'
#p '../Diff.dat' u 1:2:3 w image not
#set out

reset

# Sample Solution, FT, Chirp
set terminal epslatex color size 3in,2in lw 3

f(x, n) = (n == 0) ? 0 : f(x, n-1) + cos(2*pi*n*x)

set xl '$x$'
set grid

set xr [-2.5:2.5]
set samples 2500

set ytics 2

set output './Figures/ML1.tex'
p f(x, 4) not
set out

set ytics 4

set output './Figures/ML2.tex'
p f(x, 12) not
set out



set xr [-2.5:2.5]
set yr [-1.5:1.5]
set ytics 1
set xtics 1
set xl '$T$'

set key above horizontal

set output './Figures/Stable_Shape.tex'
p '../FT_Stable.dat' u 1:4 w l t '$|A|$', \
'../FT_Stable.dat' u 1:2 w l dt 5 t 'Re$(A)$', \
'../FT_Stable.dat' u 1:3 w l dt 4 t 'Im$(A)$'
set out

set yr [-2:2]
set xr [-1.5:1.5]

set output './Figures/Linear_Shape.tex'
p '../Linear_Solution.dat' u 1:4 w l t '$|A|$', \
'../Linear_Solution.dat' u 1:2 w l dt 5 t 'Re$(A)$', \
'../Linear_Solution.dat' u 1:3 w l dt 4 t 'Im$(A)$'
set out

set xr [-2.5:2.5]

set output './Figures/Unstable_Shape.tex'
p '../FT_Unstable.dat' u 1:4 w l t '$|A|$', \
'../FT_Unstable.dat' u 1:2 w l dt 5 t 'Re$(A)$', \
'../FT_Unstable.dat' u 1:3 w l dt 4 t 'Im$(A)$'
set out

set output './Figures/Unstable_Bad_Shape.tex'
p '../FT_Unstable_Bad.dat' u 1:4 w l t '$|A|$', \
'../FT_Unstable_Bad.dat' u 1:2 w l dt 5 t 'Re$(A)$', \
'../FT_Unstable_Bad.dat' u 1:3 w l dt 4 t 'Im$(A)$'
set out

set xr [-25:25]
set yr [0:28]
set ytics 5
set xl '$\omega$'
set yl rotate by 0 '$|\widehat{A}|$'

set xtics 10

unset format

set output './Figures/Stable_FT.tex'
p '../FT_Stable.dat' u 5:6 w l not
set out

set yr [0:60]
set ytics 10
set xr [-15:15]
set xtics 5

set output './Figures/Linear_FT.tex'
p '../Linear_Solution.dat' u 5:6 w l not
set out

set yr [0:35]
set xr [-25:25]
set xtics 10

set output './Figures/Unstable_FT.tex'
p '../FT_Unstable.dat' u 5:6 w l not
set out

set yr [0:25]

set output './Figures/Unstable_Bad_FT.tex'
p '../FT_Unstable_Bad.dat' u 5:6 w l not
set out

x0=NaN
y0=NaN

d(x,y) = (dx=x-x0, x0=x, dy=y-y0, y0=y, (dy > pi) ? (dy = dy-2*pi) : (dy), ((dy < -pi)) ? (dy = dy+2*pi) : (dy), dy/dx)


set xr [-2.5:2.5]
set yr [-20:20]
set ytics 10
set xtics 1
set xl '$T$'
set yl rotate by 0 '$-\diff{\phi}{T}$'

set output './Figures/Stable_Chirp.tex'
p '../FT_Stable.dat' u 1:(-d($1,$7)) w l not
set out

set xr [-1.5:1.5]
set yr [-10:10]
set ytics 5
set xtics 1

set output './Figures/Linear_Chirp.tex'
p '../Linear_Solution.dat' u 1:(-d($1,$7)) w l not
set out

set xr [-2.5:2.5]
set yr [-20:20]
set ytics 10

set output './Figures/Unstable_Chirp.tex'
p '../FT_Unstable.dat' u 1:(-d($1,$7)) w l not
set out

set yr [-35:35]

set output './Figures/Unstable_Bad_Chirp.tex'
p '../FT_Unstable_Bad.dat' u 1:(-d($1,$7)) w l not
set out




