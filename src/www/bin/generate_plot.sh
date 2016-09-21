#!/bin/bash

# Colors for the lines
COLORS=( '' 'forest-green' '#2ffd00' '#f92008'  '#cc84ba' '#164241' '#a70398' '#43c8c5' '#d8cd62' '#8cdf4b' ' #e72929' '#7ec843' '#70b23c' '#629c34' '#54852d' '#1e5957' '#164241' '#0f2c2b' '#071615' '#000000')

# The argument is the name of the archive
#FILE="${PLOT_DIR_UNF}/$1"
#cat $FILE | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed 's/|//' | sed 's/|//' | sed 's/^ *//' > ${PLOT_DIR}/$1

##Jobs
#FILE_JOBS="${PLOT_DIR_UNF}/jobs.$1"
#cat $FILE_JOBS | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed 's/|//' | sed 's/|//' | sed 's/^ *//' > ${PLOT_DIR}/job.$1

#Generate the .gnu file
#Info to be acquired from the file name
dir=$(dirname $1)
query=$(basename $1 | cut -d "." -f3)
service=$(basename $1 | cut -d "." -f2)
node=$(basename $1 | cut -d "." -f1)

if [ $# -ge 2 ]
then
	FILE_OUT="${dir}/energy_plot_${query}.gnu"
	IMG_OUT="${dir}/energy_plot_${query}.png"
	PDF_OUT="${dir}/energy_plot_${query}.pdf"
else
	FILE_OUT="${1%.*}.gnu"
	PDF_OUT="${dir}/${node}_${service}_${query}.pdf"
	IMG_OUT="${1%.*}.png"
fi

if [ -e "$FILE_OUT" ]
then
	rm -rf "$FILE_OUT"
fi

if [ -e "$IMG_OUT" ]
then
	rm -rf "$IMG_OUT"
fi

#Limit the x to the end of the last job
line=$(tail -1 ${1%.*}.job.dat)
arrayLine=($line)
x_limit=$(( ${arrayLine[1]}))

#Terminal info
echo "set terminal pngcairo enhanced font 'arial,10' fontscale 1.5 size 1024, 768" &>> ${FILE_OUT}

echo "set output '$IMG_OUT'" &>> ${FILE_OUT}
echo "unset border" &>> ${FILE_OUT}
echo "set grid" &>> ${FILE_OUT}
echo "set title 'Energy Timeline '" &>> ${FILE_OUT}
echo "set xlabel  'Time [s]'" &>> ${FILE_OUT}
echo "set ylabel  'Power [W]'" &>> ${FILE_OUT}
echo "set boxwidth 1" &>> ${FILE_OUT}
echo "set key under autotitle nobox" &>> ${FILE_OUT}
echo "histbin(x) = 1 * floor(0.5 + x/1)" &>> ${FILE_OUT}
echo "set xtics" &>> ${FILE_OUT}
echo "set ytics nomirror" &>> ${FILE_OUT}
echo "set y2tics" &>> ${FILE_OUT}
echo "set xrange [0: $x_limit ]" &>> ${FILE_OUT}
echo "set yrange [16:]" &>> ${FILE_OUT}
echo "set style rect fs transparent solid 0.25 noborder" &>> ${FILE_OUT}

i=0
while read line
do
	arrayLine=($line)
	i=$(( $i + 1 ))
	
	init=$(( ${arrayLine[0]}))
	end=$(( ${arrayLine[1]}))
	
	echo "set style arrow $i nohead filled size screen 0.025,30,45 fc rgb '#0B3136'" &>> ${FILE_OUT}
	echo "set arrow from $init,graph(0,0) to $init,graph(1,1) nohead as $i" &>> ${FILE_OUT}
	echo "set obj rect from $init, graph 0 to $end, graph 1 fc rgb '#FFFFFF'" &>> ${FILE_OUT}
	echo "set object 1 back lw 1.0 fc default fillstyle  default" &>> ${FILE_OUT}
	echo "set arrow from $end,graph(0,0) to $end,graph(1,1) nohead as $i" &>> ${FILE_OUT}
	echo "set label $i 'Job $i' at $init, 20, 0 rotate right" &>> ${FILE_OUT}
	
done < ${1%.*}.job.dat

i=1
echo -n "plot " &>> ${FILE_OUT}
for file in "$@"
do

	node=$(echo $file | cut -d "/" -f8 | cut -d "." -f1)
	service=$(echo $file | cut -d "." -f2)
	
	if [ "$#" -eq "$i" ]
	then
		echo "'$file' lt 1 fc rgb '${COLORS[i]}' title 'Power [W] $node $service' with lines "  &>> ${FILE_OUT}
	else
		echo -n  "'$file' lt 1 fc rgb '${COLORS[i]}' title 'Power [W] $node $service' with lines, "  &>> ${FILE_OUT}
	fi
	
	i=$(( $i + 1 ))
done

#echo "set terminal pdf enhanced font 'arial,10'" &>> ${FILE_OUT}

#echo "set output '$PDF_OUT'" &>> ${FILE_OUT}
#echo "unset border" &>> ${FILE_OUT}
#echo "set grid" &>> ${FILE_OUT}
#echo "set title 'Energy Timeline '" &>> ${FILE_OUT}
#echo "set xlabel  'Time [s]'" &>> ${FILE_OUT}
#echo "set ylabel  'Power [W]'" &>> ${FILE_OUT}
#echo "set boxwidth 1" &>> ${FILE_OUT}
#echo "set key under autotitle nobox" &>> ${FILE_OUT}
#echo "histbin(x) = 1 * floor(0.5 + x/1)" &>> ${FILE_OUT}
#echo "set xtics" &>> ${FILE_OUT}
#echo "set ytics nomirror" &>> ${FILE_OUT}
#echo "set y2tics" &>> ${FILE_OUT}
#echo "set xrange [0: $x_limit ]" &>> ${FILE_OUT}
#echo "set yrange [16:]" &>> ${FILE_OUT}
#echo "set style rect fs transparent solid 0.25 noborder" &>> ${FILE_OUT}

#i=0
#while read line
#do
	#arrayLine=($line)
	#i=$(( $i + 1 ))
	
	#init=$(( ${arrayLine[0]}))
	#end=$(( ${arrayLine[1]}))
	
	#echo "set style arrow $i nohead filled size screen 0.025,30,45 fc rgb '#0B3136'" &>> ${FILE_OUT}
	#echo "set arrow from $init,graph(0,0) to $init,graph(1,1) nohead as $i" &>> ${FILE_OUT}
	#echo "set obj rect from $init, graph 0 to $end, graph 1 fc rgb '#FFFFFF'" &>> ${FILE_OUT}
	#echo "set object 1 back lw 1.0 fc default fillstyle  default" &>> ${FILE_OUT}
	#echo "set arrow from $end,graph(0,0) to $end,graph(1,1) nohead as $i" &>> ${FILE_OUT}
	#echo "set label $i 'Job $i' at $init, 20, 0 rotate right" &>> ${FILE_OUT}
	
#done < ${1%.*}.job.dat

#echo "replot" &>> ${FILE_OUT}	
	
#echo "plot '$1' lt 1 fc rgb 'forest-green' title 'Power [W]' with lines"  &>> ${FILE_OUT}	
#'${PLOT_DIR}/$1' u 1:2:3 title 'Std Dev' w filledcu" &>> ${FILE_OUT}


#Generate plot
gnuplot ${FILE_OUT}

chmod 777 ${FILE_OUT}

# error bars: plot "file.txt" using 1:2:($2-$3):($2+$3) with errorbars
