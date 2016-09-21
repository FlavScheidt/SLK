set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/Temperature.query.png'
unset border
set grid
set style fill  solid 0.25 noborder
set boxwidth 0.5 absolute
set xtics rotate
set title 'Comparison by query '
set xlabel  'Query'
set ylabel  'Temperature [C]'
set style histogram errorbars gap 2 lw 1
set style data histograms
set xrange [-0.5:21.5]
set key under autotitle nobox
plot '//home/flav/salaak/src/www/plots/Temperature.query.dat' using 0:2:3:xtic(1) with boxerrorbars fc rgb 'forest-green' title 'Temperature [C]'
