set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768
set output '/home/flav/salaak/src/www/plots/bar.q07.png'
unset border
set grid
set style fill  solid 0.25 noborder
set boxwidth 0.75 absolute
set title 'Comparison by Job q07'
set xlabel  'Job'
set ylabel  'Power[W]'
set style histogram clustered 
set style data histograms
set key under autotitle nobox
set yrange [0:]
set xtics  norangelimit
set xtics   ()
plot  '/home/flav/salaak/src/www/plots/bar.q07.1.juno.datanode.dat' u 4:xtic(1) with histogram title 'juno datanode', \
'/home/flav/salaak/src/www/plots/bar.q07.1.juno.tasktracker.dat' u 4:xtic(1) with histogram title 'juno tasktracker', \
'/home/flav/salaak/src/www/plots/bar.q07.1.pallas.datanode.dat' u 4:xtic(1) with histogram title 'pallas datanode', \
'/home/flav/salaak/src/www/plots/bar.q07.1.pallas.tasktracker.dat' u 4:xtic(1) with histogram title 'pallas tasktracker'
