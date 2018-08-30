set terminal pngcairo size 700,524 enhanced font 'Verdana,10'

set xr [1500:2600]
set yr [-0.5:0.5]
set grid

do for [i=001:200:2] {
	j = i + 1
	set output sprintf('./Break/Plot%03.0f.png', i)
	plot 'Break.dat' u 0:(sqrt(column(i)**2 + column(j)**2))  w l t 'Magnitude', \
	'Break.dat' u 0:i w l t 'Real', \
	'Break.dat' u 0:j w l t 'Imaginary'
	set out

}
