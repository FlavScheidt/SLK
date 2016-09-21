set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/juno.datanode.q02.png'
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
set xrange [0: 180 ]
set yrange [16:]
set style rect fs transparent solid 0.25 noborder
set style arrow 1 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 6,graph(0,0) to 6,graph(1,1) nohead as 1
set obj rect from 6, graph 0 to 24, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 24,graph(0,0) to 24,graph(1,1) nohead as 1
set label 1 'Job 1' at 6, 20, 0 rotate right
set style arrow 2 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 25,graph(0,0) to 25,graph(1,1) nohead as 2
set obj rect from 25, graph 0 to 45, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 45,graph(0,0) to 45,graph(1,1) nohead as 2
set label 2 'Job 2' at 25, 20, 0 rotate right
set style arrow 3 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 46,graph(0,0) to 46,graph(1,1) nohead as 3
set obj rect from 46, graph 0 to 72, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 72,graph(0,0) to 72,graph(1,1) nohead as 3
set label 3 'Job 3' at 46, 20, 0 rotate right
set style arrow 4 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 73,graph(0,0) to 73,graph(1,1) nohead as 4
set obj rect from 73, graph 0 to 96, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 96,graph(0,0) to 96,graph(1,1) nohead as 4
set label 4 'Job 4' at 73, 20, 0 rotate right
set style arrow 5 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 97,graph(0,0) to 97,graph(1,1) nohead as 5
set obj rect from 97, graph 0 to 117, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 117,graph(0,0) to 117,graph(1,1) nohead as 5
set label 5 'Job 5' at 97, 20, 0 rotate right
set style arrow 6 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 118,graph(0,0) to 118,graph(1,1) nohead as 6
set obj rect from 118, graph 0 to 138, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 138,graph(0,0) to 138,graph(1,1) nohead as 6
set label 6 'Job 6' at 118, 20, 0 rotate right
set style arrow 7 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 139,graph(0,0) to 139,graph(1,1) nohead as 7
set obj rect from 139, graph 0 to 159, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 159,graph(0,0) to 159,graph(1,1) nohead as 7
set label 7 'Job 7' at 139, 20, 0 rotate right
set style arrow 8 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 160,graph(0,0) to 160,graph(1,1) nohead as 8
set obj rect from 160, graph 0 to 180, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 180,graph(0,0) to 180,graph(1,1) nohead as 8
set label 8 'Job 8' at 160, 20, 0 rotate right
plot '/home/flav/salaak/src/www/plots/juno.datanode.q02.dat' lt 1 fc rgb 'forest-green' title 'Power [W] juno datanode' with lines 
