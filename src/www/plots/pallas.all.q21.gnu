set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/pallas.all.q21.png'
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
set xrange [0: 369 ]
set yrange [16:]
set style rect fs transparent solid 0.25 noborder
set style arrow 1 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 5,graph(0,0) to 5,graph(1,1) nohead as 1
set obj rect from 5, graph 0 to 72, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 72,graph(0,0) to 72,graph(1,1) nohead as 1
set label 1 'Job 1' at 5, 20, 0 rotate right
set style arrow 2 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 74,graph(0,0) to 74,graph(1,1) nohead as 2
set obj rect from 74, graph 0 to 142, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 142,graph(0,0) to 142,graph(1,1) nohead as 2
set label 2 'Job 2' at 74, 20, 0 rotate right
set style arrow 3 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 142,graph(0,0) to 142,graph(1,1) nohead as 3
set obj rect from 142, graph 0 to 163, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 163,graph(0,0) to 163,graph(1,1) nohead as 3
set label 3 'Job 3' at 142, 20, 0 rotate right
set style arrow 4 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 163,graph(0,0) to 163,graph(1,1) nohead as 4
set obj rect from 163, graph 0 to 220, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 220,graph(0,0) to 220,graph(1,1) nohead as 4
set label 4 'Job 4' at 163, 20, 0 rotate right
set style arrow 5 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 221,graph(0,0) to 221,graph(1,1) nohead as 5
set obj rect from 221, graph 0 to 250, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 250,graph(0,0) to 250,graph(1,1) nohead as 5
set label 5 'Job 5' at 221, 20, 0 rotate right
set style arrow 6 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 250,graph(0,0) to 250,graph(1,1) nohead as 6
set obj rect from 250, graph 0 to 277, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 277,graph(0,0) to 277,graph(1,1) nohead as 6
set label 6 'Job 6' at 250, 20, 0 rotate right
set style arrow 7 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 280,graph(0,0) to 280,graph(1,1) nohead as 7
set obj rect from 280, graph 0 to 306, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 306,graph(0,0) to 306,graph(1,1) nohead as 7
set label 7 'Job 7' at 280, 20, 0 rotate right
set style arrow 8 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 307,graph(0,0) to 307,graph(1,1) nohead as 8
set obj rect from 307, graph 0 to 327, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 327,graph(0,0) to 327,graph(1,1) nohead as 8
set label 8 'Job 8' at 307, 20, 0 rotate right
set style arrow 9 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 328,graph(0,0) to 328,graph(1,1) nohead as 9
set obj rect from 328, graph 0 to 348, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 348,graph(0,0) to 348,graph(1,1) nohead as 9
set label 9 'Job 9' at 328, 20, 0 rotate right
set style arrow 10 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 349,graph(0,0) to 349,graph(1,1) nohead as 10
set obj rect from 349, graph 0 to 369, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 369,graph(0,0) to 369,graph(1,1) nohead as 10
set label 10 'Job 10' at 349, 20, 0 rotate right
plot '/home/flav/salaak/src/www/plots/pallas.all.q21.dat' lt 1 fc rgb 'forest-green' title 'Power [W] pallas all' with lines 
