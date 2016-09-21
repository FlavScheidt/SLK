set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/energy_plot_q07.png'
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
set xrange [0: 286 ]
set yrange [16:]
set style rect fs transparent solid 0.25 noborder
set style arrow 1 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 5,graph(0,0) to 5,graph(1,1) nohead as 1
set obj rect from 5, graph 0 to 24, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 24,graph(0,0) to 24,graph(1,1) nohead as 1
set label 1 'Job 1' at 5, 20, 0 rotate right
set style arrow 2 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 25,graph(0,0) to 25,graph(1,1) nohead as 2
set obj rect from 25, graph 0 to 45, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 45,graph(0,0) to 45,graph(1,1) nohead as 2
set label 2 'Job 2' at 25, 20, 0 rotate right
set style arrow 3 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 46,graph(0,0) to 46,graph(1,1) nohead as 3
set obj rect from 46, graph 0 to 57, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 57,graph(0,0) to 57,graph(1,1) nohead as 3
set label 3 'Job 3' at 46, 20, 0 rotate right
set style arrow 4 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 58,graph(0,0) to 58,graph(1,1) nohead as 4
set obj rect from 58, graph 0 to 69, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 69,graph(0,0) to 69,graph(1,1) nohead as 4
set label 4 'Job 4' at 58, 20, 0 rotate right
set style arrow 5 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 70,graph(0,0) to 70,graph(1,1) nohead as 5
set obj rect from 70, graph 0 to 130, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 130,graph(0,0) to 130,graph(1,1) nohead as 5
set label 5 'Job 5' at 70, 20, 0 rotate right
set style arrow 6 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 131,graph(0,0) to 131,graph(1,1) nohead as 6
set obj rect from 131, graph 0 to 166, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 166,graph(0,0) to 166,graph(1,1) nohead as 6
set label 6 'Job 6' at 131, 20, 0 rotate right
set style arrow 7 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 167,graph(0,0) to 167,graph(1,1) nohead as 7
set obj rect from 167, graph 0 to 205, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 205,graph(0,0) to 205,graph(1,1) nohead as 7
set label 7 'Job 7' at 167, 20, 0 rotate right
set style arrow 8 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 206,graph(0,0) to 206,graph(1,1) nohead as 8
set obj rect from 206, graph 0 to 244, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 244,graph(0,0) to 244,graph(1,1) nohead as 8
set label 8 'Job 8' at 206, 20, 0 rotate right
set style arrow 9 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 245,graph(0,0) to 245,graph(1,1) nohead as 9
set obj rect from 245, graph 0 to 265, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 265,graph(0,0) to 265,graph(1,1) nohead as 9
set label 9 'Job 9' at 245, 20, 0 rotate right
set style arrow 10 nohead filled size screen 0.025,30,45 fc rgb '#0B3136'
set arrow from 265,graph(0,0) to 265,graph(1,1) nohead as 10
set obj rect from 265, graph 0 to 286, graph 1 fc rgb '#FFFFFF'
set object 1 back lw 1.0 fc default fillstyle  default
set arrow from 286,graph(0,0) to 286,graph(1,1) nohead as 10
set label 10 'Job 10' at 265, 20, 0 rotate right
plot '/home/flav/salaak/src/www/plots/juno.tasktracker.q07.dat' lt 1 fc rgb 'forest-green' title 'Power [W] juno tasktracker' with lines, '/home/flav/salaak/src/www/plots/juno.datanode.q07.dat' lt 1 fc rgb '#2ffd00' title 'Power [W] juno datanode' with lines, '/home/flav/salaak/src/www/plots/pallas.tasktracker.q07.dat' lt 1 fc rgb '#f92008' title 'Power [W] pallas tasktracker' with lines, '/home/flav/salaak/src/www/plots/pallas.datanode.q07.dat' lt 1 fc rgb '#cc84ba' title 'Power [W] pallas datanode' with lines 
