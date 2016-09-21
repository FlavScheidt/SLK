set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/juno.datanode.q20.png'
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
set xrange [0: 216 ]
set yrange [16:]
set style rect fs transparent solid 0.25 noborder
set style arrow 1 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 6,graph(0,0) to 6,graph(1,1) nohead as 1
set obj rect from 6, graph 0 to 24, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 24,graph(0,0) to 24,graph(1,1) nohead as 1
set label 1 'Job 1' at 6, 20, 0 rotate right
set style arrow 2 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 26,graph(0,0) to 26,graph(1,1) nohead as 2
set obj rect from 26, graph 0 to 81, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 81,graph(0,0) to 81,graph(1,1) nohead as 2
set label 2 'Job 2' at 26, 20, 0 rotate right
set style arrow 3 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 83,graph(0,0) to 83,graph(1,1) nohead as 3
set obj rect from 83, graph 0 to 108, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 108,graph(0,0) to 108,graph(1,1) nohead as 3
set label 3 'Job 3' at 83, 20, 0 rotate right
set style arrow 4 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 109,graph(0,0) to 109,graph(1,1) nohead as 4
set obj rect from 109, graph 0 to 132, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 132,graph(0,0) to 132,graph(1,1) nohead as 4
set label 4 'Job 4' at 109, 20, 0 rotate right
set style arrow 5 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 134,graph(0,0) to 134,graph(1,1) nohead as 5
set obj rect from 134, graph 0 to 153, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 153,graph(0,0) to 153,graph(1,1) nohead as 5
set label 5 'Job 5' at 134, 20, 0 rotate right
set style arrow 6 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 155,graph(0,0) to 155,graph(1,1) nohead as 6
set obj rect from 155, graph 0 to 174, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 174,graph(0,0) to 174,graph(1,1) nohead as 6
set label 6 'Job 6' at 155, 20, 0 rotate right
set style arrow 7 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 175,graph(0,0) to 175,graph(1,1) nohead as 7
set obj rect from 175, graph 0 to 195, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 195,graph(0,0) to 195,graph(1,1) nohead as 7
set label 7 'Job 7' at 175, 20, 0 rotate right
set style arrow 8 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 197,graph(0,0) to 197,graph(1,1) nohead as 8
set obj rect from 197, graph 0 to 216, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 216,graph(0,0) to 216,graph(1,1) nohead as 8
set label 8 'Job 8' at 197, 20, 0 rotate right
plot '/home/flav/salaak/src/www/plots/juno.datanode.q20.dat' lt 1 fc rgb 'forest-green' title 'Power [W] juno datanode' with lines 
