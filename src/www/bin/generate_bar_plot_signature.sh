#!/bin/bash

#The argument is the name of the archive
#Format: metric.[query | job].dat

dir=$(dirname $1)

FILE_OUT="${dir}/signature_ranking.gnu"
PDF_OUT="${dir}/signature_ranking.pdf"
IMG_OUT="${dir}/signature_ranking.png"

if [ -e "$FILE_OUT" ]
then
	rm -rf "$FILE_OUT"
fi

if [ -e "$IMG_OUT" ]
then
	rm -rf "$IMG_OUT"
fi

#Terminal info
echo "set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768" &>> ${FILE_OUT}

echo "set output '$IMG_OUT'" &>> ${FILE_OUT}
echo "unset border" &>> ${FILE_OUT}
echo "set grid" &>> ${FILE_OUT}
echo "set style fill  solid 0.25 noborder" &>> ${FILE_OUT}
echo "set boxwidth 0.5 absolute" &>> ${FILE_OUT}
echo "set title 'Ranking by Code Signature'" &>> ${FILE_OUT}
echo "set xlabel  'Signature'" &>> ${FILE_OUT}
echo "set ylabel  'Power [W]'" &>> ${FILE_OUT}
echo "set style histogram errorbars gap 2 lw 1" &>> ${FILE_OUT}
echo "set style data histograms" &>> ${FILE_OUT}
echo "set xrange [-0.5:31.5]" &>> ${FILE_OUT}
echo "set yrange [0:]" &>> ${FILE_OUT}
echo "set key under autotitle nobox" &>> ${FILE_OUT}

echo "plot '$1' using 0:2:3:xtic(1) with boxerrorbars fc rgb 'forest-green' title 'Power [W]'" &>> ${FILE_OUT}

#echo "set terminal pdf enhanced font 'arial,10'" &>> ${FILE_OUT}

#echo "set output '$PDF_OUT'" &>> ${FILE_OUT}
#echo "unset border" &>> ${FILE_OUT}
#echo "set grid" &>> ${FILE_OUT}
#echo "set style fill  solid 0.25 noborder" &>> ${FILE_OUT}
#echo "set boxwidth 0.5 absolute" &>> ${FILE_OUT}
#echo "set title 'Ranking by Code Signature'" &>> ${FILE_OUT}
#echo "set xlabel  'Signature'" &>> ${FILE_OUT}
#echo "set ylabel  'Power [W]'" &>> ${FILE_OUT}
#echo "set style histogram errorbars gap 2 lw 1" &>> ${FILE_OUT}
#echo "set style data histograms" &>> ${FILE_OUT}
#echo "set xrange [-0.5:31.5]" &>> ${FILE_OUT}
#echo "set yrange [0:]" &>> ${FILE_OUT}
#echo "set key under autotitle nobox" &>> ${FILE_OUT}
#echo "replot" &>> ${FILE_OUT}

#echo -n "plot '${PLOT_DIR}/$1' using 2:xtic(1) with boxes fc rgb 'forest-green' title '${metric} ${2}', " &>> ${FILE_OUT}
#echo "'${PLOT_DIR}/$1' u 3:2:4 title 'Std Dev' w yerrorbars" &>> ${FILE_OUT}

#Generate plot
gnuplot ${FILE_OUT}


