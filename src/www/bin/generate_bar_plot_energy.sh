#!/bin/bash

# Colors for the lines
COLORS=( '' 'forest-green' '#2ffd00' '#f92008'  '#cc84ba' '#164241' '#a70398' '#43c8c5' '#d8cd62' '#8cdf4b' ' #e72929' '#7ec843' '#70b23c' '#629c34' '#54852d' '#1e5957' '#164241' '#0f2c2b' '#071615' '#000000')

query=$(basename $1 | cut -d "." -f2)
dir=$(dirname $1)

FILE_OUT="${dir}/bar.${query}.gnu"
PDF_OUT="${dir}/bar_${query}.pdf"
IMG_OUT="${dir}/bar.${query}.png"

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
echo "set boxwidth 0.75 absolute" &>> ${FILE_OUT}
echo "set title 'Comparison by Job $query'" &>> ${FILE_OUT}
echo "set xlabel  'Job'" &>> ${FILE_OUT}
echo "set ylabel  'Power[W]'" &>> ${FILE_OUT}
echo "set style histogram clustered " &>> ${FILE_OUT}
echo "set style data histograms" &>> ${FILE_OUT}
echo "set key under autotitle nobox" &>> ${FILE_OUT}
echo "set yrange [0:]" &>> ${FILE_OUT}
echo "set xtics  norangelimit" &>> ${FILE_OUT}
echo "set xtics   ()" &>> ${FILE_OUT}

echo -n "plot  " &>> ${FILE_OUT}
for file in "$@"
do
	node=$(basename $file | cut -d "." -f4)
	service=$(basename $file | cut -d "." -f5)
	nJobs=$(cat $file | wc -l)


	echo -n "'$file' u 4:xtic(1) with histogram title '$node $service', "  &>> ${FILE_OUT}

	echo "\\"  &>> ${FILE_OUT}
done

sed -i '$s/...$//' ${FILE_OUT}

#echo "set terminal pdf enhanced font 'arial,10'" &>> ${FILE_OUT}

#echo "set output '$PDF_OUT'" &>> ${FILE_OUT}
#echo "unset border" &>> ${FILE_OUT}
#echo "set grid" &>> ${FILE_OUT}
#echo "set style fill  solid 0.25 noborder" &>> ${FILE_OUT}
#echo "set boxwidth 0.75 absolute" &>> ${FILE_OUT}
#echo "set title 'Comparison by Job $query'" &>> ${FILE_OUT}
#echo "set xlabel  'Job'" &>> ${FILE_OUT}
#echo "set ylabel  'Power[W]'" &>> ${FILE_OUT}
#echo "set style histogram clustered " &>> ${FILE_OUT}
#echo "set style data histograms" &>> ${FILE_OUT}
#echo "set key under autotitle nobox" &>> ${FILE_OUT}
#echo "set xtics  norangelimit" &>> ${FILE_OUT}
#echo "set xtics   ()" &>> ${FILE_OUT}
#echo "set yrange [0:]" &>> ${FILE_OUT}
#echo "replot" &>> ${FILE_OUT}

#Generate plot
gnuplot ${FILE_OUT}


