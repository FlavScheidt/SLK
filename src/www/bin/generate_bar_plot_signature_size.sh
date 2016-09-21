#!/bin/bash

# Colors for the lines
COLORS=( '' 'forest-green' '#2ffd00' '#f92008'  '#cc84ba' '#164241' '#a70398' '#43c8c5' '#d8cd62' '#8cdf4b' ' #e72929' '#7ec843' '#70b23c' '#629c34' '#54852d' '#1e5957' '#164241' '#0f2c2b' '#071615' '#000000')

dir=$(dirname $1)
sz=$(basename $1 | cut -d "." -f2)

FILE_OUT="${dir}/signature_ranking_${sz}.gnu"
PDF_OUT="${dir}/signature_ranking_${sz}.pdf"
IMG_OUT="${dir}/signature_ranking_${sz}.png"

if [ -e "$FILE_OUT" ]
then
	rm -rf "$FILE_OUT"
fi

if [ -e "$IMG_OUT" ]
then
	rm -rf "$IMG_OUT"
fi

nJobs=$(cat ${PLOT_DIR}/$1 | wc -l)

#Terminal info
echo "set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768" &>> ${FILE_OUT}
echo "set output '$IMG_OUT'" &>> ${FILE_OUT}
echo "unset border" &>> ${FILE_OUT}
echo "set grid" &>> ${FILE_OUT}
echo "set style fill  solid 0.25 noborder" &>> ${FILE_OUT}
echo "set boxwidth 0.5 absolute" &>> ${FILE_OUT}
echo "set title 'Ranking $signature '" &>> ${FILE_OUT}
echo "set xlabel  'Query.Job'" &>> ${FILE_OUT}
echo "set ylabel  'Energy PKG [W]'" &>> ${FILE_OUT}
echo "set style histogram errorbars gap 2 lw 1" &>> ${FILE_OUT}
echo "set style data histograms" &>> ${FILE_OUT}
echo "set xrange [-0.5:${nJobs}]" &>> ${FILE_OUT}
echo "set yrange [0:]" &>> ${FILE_OUT}
echo "set key under autotitle nobox" &>> ${FILE_OUT}
echo "set ytics nomirror" &>> ${FILE_OUT}
echo "set y2tics nomirror" &>> ${FILE_OUT}
echo "set y2range [0:]" &>> ${FILE_OUT}
echo "set y2label 'Operators Set ID' " &>> ${FILE_OUT}

echo "plot '${PLOT_DIR}/$1' using 0:2:3:xtic(1) with boxerrorbars fc rgb 'forest-green' title 'Energy PKG [W]' axes x1y1, \\" &>> ${FILE_OUT}
echo "'${PLOT_DIR}/$2' u 0:2 w points t 'Oprators Set ID' fc rgb '#164241' axes x1y2" &>> ${FILE_OUT}


#echo "set terminal pdf enhanced font 'arial,20'" &>> ${FILE_OUT}

#echo "set output '$PDF_OUT'" &>> ${FILE_OUT}
#echo "unset border" &>> ${FILE_OUT}
#echo "set grid" &>> ${FILE_OUT}
#echo "set style fill  solid 0.25 noborder" &>> ${FILE_OUT}
#echo "set boxwidth 0.5 absolute" &>> ${FILE_OUT}
#echo "set title 'Ranking $signature '" &>> ${FILE_OUT}
#echo "set xlabel  'Query.Job'" &>> ${FILE_OUT}
#echo "set ylabel  'Energy PKG [W]'" &>> ${FILE_OUT}
#echo "set style histogram errorbars gap 2 lw 1" &>> ${FILE_OUT}
#echo "set style data histograms" &>> ${FILE_OUT}
#echo "set xrange [-0.5:${nJobs}]" &>> ${FILE_OUT}
#echo "set yrange [0:]" &>> ${FILE_OUT}
#echo "set key under autotitle nobox" &>> ${FILE_OUT}
#echo "set ytics nomirror" &>> ${FILE_OUT}
#echo "set y2tics nomirror" &>> ${FILE_OUT}
#echo "set y2range [0:]" &>> ${FILE_OUT}
#echo "set y2label 'Operators Set ID' " &>> ${FILE_OUT}
#echo "replot" &>> ${FILE_OUT}

#Generate plot
gnuplot ${FILE_OUT}

