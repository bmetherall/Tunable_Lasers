set terminal epslatex color size 3.25in,2in lw 3 standalone font '10'
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

set zl offset screen 0.075,0
set yl offset screen 0.1,0

set xyplane 0

set view 45,325,1.25

unset colorbox

set lmargin 5.5

set out 'Evo.tex'

sp 'EBig.dat' u ($2*0.1):1:3 w pm3d not, \
'Shell1.dat' u 2:1:3 w l lw 0.2 lc 8 not, \
'Shell2.dat' u ($2*0.1):1:3 w l lw 0.2 lc 8 not

set out
