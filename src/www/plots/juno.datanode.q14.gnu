set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/juno.datanode.q14.png'
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
set xrange [0: 57 ]
set yrange [16:]
set style rect fs transparent solid 0.25 noborder
set style arrow 1 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 5,graph(0,0) to 5,graph(1,1) nohead as 1
set obj rect from 5, graph 0 to 36, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 36,graph(0,0) to 36,graph(1,1) nohead as 1
set label 1 'Job 1' at 5, 20, 0 rotate right
set style arrow 2 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 37,graph(0,0) to 37,graph(1,1) nohead as 2
set obj rect from 37, graph 0 to 57, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 57,graph(0,0) to 57,graph(1,1) nohead as 2
set label 2 'Job 2' at 37, 20, 0 rotate right
plot '/home/flav/salaak/src/www/plots/juno.datanode.q14.dat' lt 1 fc rgb 'forest-green' title 'Power [W] juno datanode' with lines 
