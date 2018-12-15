set terminal epslatex color size 3.5in,2.125in lw 2
# Constant power things
Ps = 1
f = 1
g = 1
a = 0.1
f(x,y) = Ps / (sqrt(pi) * f) * (y / (2 * x))**(1/4) * (g / (sqrt(x * y / 2) + a) -1)

set key opaque
set key width -5

set grid
set xr [0:10]
set yr [0:10]
set xl '$\epsilon$ (AU)'
set yl '$|\beta_2|$ (AU)'

# Put contours in file
set contour base 
set cntrparam levels incremental 0, 0.1
unset surface 
set table 'curve.dat'
set isosamples 1000
splot f(x,y) 
unset table 

# Plot everything
set output 'Param.tex'
p 2 / x t 'Constant Gain' lc 1 dt 5, \
for [g=1:5] 2 * g**2 / x not lc 1 dt 5, \
0 t 'Constant Duration' lc 7 dt 4, \
for [T=0:20:2] x / 2 * (T/10.0)**4 not lc 7 dt 4, \
'curve.dat' w l t 'Constant Power' lc 3
set out

reset

set terminal epslatex color size 3.5in,2.375in lw 3
set grid
set xr [-2:2]
set xl '$T$'
set xtics 1
set ytics 1
set yl '$|A|^2$ (AU)'

set output 'Shape.tex'

p '../Stable/Envelope25.dat' u 1:(10**3*$4**2) w l t 'Stable', \
'../Break/Envelope25.dat' u 1:(10**3*$4**2) w l dt 5 t 'Unstable'
set out

reset

set terminal epslatex color size 3.5in,2.5in lw 3
set grid
set xl '$\omega$'
set yl '$|\widehat{A}|$'
set xr [-40:40]
set ytics 3
set xtics 20

set output 'Transform.tex'
p '../Stable/Envelope25.dat' u 6:($7**2) w l t 'Stable', \
'../Break/Envelope25.dat' u 6:($7**2) w l dt 5 t 'Unstable'
set out

reset

set terminal epslatex color size 3.5in,2.5in lw 3
#d2(x,y) = ($0 == 0) ? (x1 = x, y1 = y, 1/0) : (x2 = x1, x1 = x, y2 = y1, y1 = y, if (x1 > x2 + pi) (x2 = x2 + 2 * pi), (y1-y2)/(x1-x2))

x0=NaN
y0=NaN

d(x,y) = (dx=x-x0, x0=x, dy=y-y0, y0=y, (dy > pi) ? (dy = dy-2*pi) : (dy), ((dy < -pi)) ? (dy = dy+2*pi) : (dy), dy/dx)

set grid
set xr [-2:2]
set yr [-20:20]
set xl '$T$'
set xtics 1
set ytics 10
set yl '$-\diff{\varphi}{T}$'
set key bottom right opaque

set output 'Chirp.tex'
p '../Stable/Envelope25.dat' u 1:(-d($1,$5)) w l t 'Stable', \
'../Break/Envelope25.dat' u 1:(-d($1,$5)) w l dt 5 t 'Unstable'
set out

reset

set terminal epslatex color size 3.25in,2.5in lw 3
load '/home/brady/Templates/Blues.p'
set grid
set xl '$s$'
set yl '$b$'
set cbl '$E \, (\times 10^{-3})$'
set cbtics 1
set view map
set cbr [0:4]

set output 'Energy.tex'
sp '../8000-04-01-DM-Z.dat' u 1:2:(1000*$4) w image not, \
'EnergyContours.dat' w l lc 'black' lw 0.5 not
set out

reset

set terminal epslatex color size 3in,2.25in lw 3
set grid
set xl '$s$'
set yl '$b$'
set cbl 'Error'
set xr [0:1]
set ytics 10
set cbtics 0.2
set view map

load '/home/brady/Templates/Blues.p'

set cbr [0:0.8]
set output 'Big.tex'
sp '../8000-04-01-DM.dat' using 1:2:3 w image not, \
'../TM_Contours.dat' w l lw 0.5 lc 'black' not
set out

reset

set terminal epslatex color size 3in,2.25in lw 3
set grid
set xl '$s$'
set yl '$b$'
set cbl 'Error'
set xr [0:0.25]
set view map

load '/home/brady/Templates/Blues.p'

set cbr [0:0.8]
set cbtics 0.2

set cntrlabel start 1
set output 'Zoom.tex'
sp '../8000-04-01-DM-Z.dat' using 1:2:3 w image not, \
'../TM_Contours.dat' u ($1/4):($2/20):3 w l lw 0.5 lc 'black' not
set out

reset

set terminal epslatex color size 3in,2.25in lw 3
set grid
set xl '$s$'
set yl '$b$'
set cbl 'Error'
set xr [0:1]
set ytics 10
set view map

load '/home/brady/Templates/Blues.p'

set cbr [0:0.8]
set cbtics 0.2
set output 'Switch.tex'
sp '../8000-04-01-MD.dat' using 1:2:3 w image not
set out

reset

set terminal epslatex color size 3in,2.25in lw 3
set grid
set xl '$s$'
set yl '$b$'
set cbl 'Error'
set xr [0:0.25]
set view map

load '/home/brady/Templates/Blues.p'

set cbr [0:0.8]
set cbtics 0.2
set output 'SwitchZoom.tex'
sp '../8000-04-01-MD-Z.dat' using 1:2:3 w image not
set out



