set terminal epslatex color size 6in,3.7in lw 3

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

set output './Figures/Variance.tex'
set grid
p '../LinearAnalytic.dat' u 1:4 t 'Analytic $\sigma$' w l, \
'../LinearAnalytic.dat' u 1:5 t 'Analytic Chirp' w l lc 2 dt 5, \
'../Linear.dat' u 1:4 t 'Sim $\sigma$' pt 7 lc 1, \
'../Linear.dat' u 1:5 t 'Sim Chirp' pt 7 lc 2
set out

reset

# Power and Energy
set xl '$s$'
set yr [0:3]
set xr [0:3]
set key top right

set output './Figures/LinearPlot.tex'
set grid
p '../LinearAnalytic.dat' u 1:2 t 'Analytic Energy' w l, \
'../LinearAnalytic.dat' u 1:3 t 'Analytic Amplitude' w l dt 5, \
'../Linear.dat' u 1:2 t 'Energy' pt 7 lc 1, \
'../Linear.dat' u 1:3 t 'Amplitude' pt 7 lc 2
set out

reset

# Parameter Space
#set xl '$s$'
#set yl rotate by 0 '$b$'
#set cbl rotate by 0 '$E$'
#load '/home/brady/Templates/Blues.p'
#set grid front
#set cbr [0:3]
#set view map
#
#unset cl
#set contour base
#set cntrparam levels incremental 0, 0.25, 3
#
#set output './Figures/Stability.tex'
#sp '../8000-04-01-DM.dat' u 1:2:4 w pm3d not lw 0.3
#set out
#
#set output './Figures/StabilityZoom.tex'
#sp '../8000-04-01-DM-Z.dat' u 1:2:4 w pm3d not lw 0.3
#set out
#
#set output './Figures/StabilitySwitch.tex'
#sp '../8000-04-01-MD.dat' u 1:2:4 w pm3d not lw 0.3
#set out
#
#set output './Figures/StabilitySwitchZoom.tex'
#sp '../8000-04-01-MD-Z.dat' u 1:2:4 w pm3d not lw 0.3
#set out

reset

