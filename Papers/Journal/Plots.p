set terminal epslatex color size 3.5in,2.15in lw 3 standalone font ',10'
load 'YGB.p'
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

set out 'Evo.tex'

set multiplot

set size 1,1.2

sp 'EBig.dat' u ($2*0.1):1:3 w pm3d not, \
'Shell1.dat' u 2:1:3 w l lw 0.2 lc 8 not, \
'Shell2.dat' u ($2*0.1):1:3 w l lw 0.2 lc 8 not

unset multiplot

set out


reset

load 'YGB.p'
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


set out 'Conv.tex'

p 'Converge.dat' u 1:2:3 w image not, \
'Contours.dat' u 1:2 w l lc 8 lw 0.2 not

set out























