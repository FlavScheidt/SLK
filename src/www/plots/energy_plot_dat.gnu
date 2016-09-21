set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/energy_plot_dat.png'
unset border
set grid
set title 'Energy Timeline '
set xlabel  'Time [s]'
set ylabel  'Power [W]'
set boxwidth 1
set key under autotitle nobox
histbin(x) = 1 * floor(0.5 + x/1)
set xtics
set ytics nomirror
set y2tics
set xrange [0: 0 ]
set yrange [16:]
set style rect fs transparent solid 0.25 noborder
plot '/home/flav/salaak/src/www/plots/juno.q21.dat' lt 1 fc rgb 'forest-green' title 'Power [W] juno q21' with lines, '/home/flav/salaak/src/www/plots/pallas.q21.dat' lt 1 fc rgb '#2ffd00' title 'Power [W] pallas q21' with lines 
