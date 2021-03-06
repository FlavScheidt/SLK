set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/juno.datanode.q22.png'
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
set xrange [0: 169 ]
set yrange [16:]
set style rect fs transparent solid 0.25 noborder
set style arrow 1 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 5,graph(0,0) to 5,graph(1,1) nohead as 1
set obj rect from 5, graph 0 to 19, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 19,graph(0,0) to 19,graph(1,1) nohead as 1
set label 1 'Job 1' at 5, 20, 0 rotate right
set style arrow 2 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 19,graph(0,0) to 19,graph(1,1) nohead as 2
set obj rect from 19, graph 0 to 31, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 31,graph(0,0) to 31,graph(1,1) nohead as 2
set label 2 'Job 2' at 19, 20, 0 rotate right
set style arrow 3 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 33,graph(0,0) to 33,graph(1,1) nohead as 3
set obj rect from 33, graph 0 to 52, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 52,graph(0,0) to 52,graph(1,1) nohead as 3
set label 3 'Job 3' at 33, 20, 0 rotate right
set style arrow 4 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 52,graph(0,0) to 52,graph(1,1) nohead as 4
set obj rect from 52, graph 0 to 82, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 82,graph(0,0) to 82,graph(1,1) nohead as 4
set label 4 'Job 4' at 52, 20, 0 rotate right
set style arrow 5 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 83,graph(0,0) to 83,graph(1,1) nohead as 5
set obj rect from 83, graph 0 to 106, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 106,graph(0,0) to 106,graph(1,1) nohead as 5
set label 5 'Job 5' at 83, 20, 0 rotate right
set style arrow 6 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 107,graph(0,0) to 107,graph(1,1) nohead as 6
set obj rect from 107, graph 0 to 127, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 127,graph(0,0) to 127,graph(1,1) nohead as 6
set label 6 'Job 6' at 107, 20, 0 rotate right
set style arrow 7 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 127,graph(0,0) to 127,graph(1,1) nohead as 7
set obj rect from 127, graph 0 to 148, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 148,graph(0,0) to 148,graph(1,1) nohead as 7
set label 7 'Job 7' at 127, 20, 0 rotate right
set style arrow 8 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 149,graph(0,0) to 149,graph(1,1) nohead as 8
set obj rect from 149, graph 0 to 169, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 169,graph(0,0) to 169,graph(1,1) nohead as 8
set label 8 'Job 8' at 149, 20, 0 rotate right
plot '/home/flav/salaak/src/www/plots/juno.datanode.q22.dat' lt 1 fc rgb 'forest-green' title 'Power [W] juno datanode' with lines 
