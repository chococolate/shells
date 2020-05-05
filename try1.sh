#!/bin/bash
function help()
{
	echo "usage:[options] [][][]"
	echo "options:"
	echo "-q [quality_number][directory]"
	echo "-p [percent][directory]"
	echo "-w [watermark_text][directory]"
	echo "-r [head|tail] [text][directory]"
	echo "-t [directory]"
	echo "-h"

}
function reduceQuality()
{
	images=($(find "$2" -regex '.*\.jpg'))
	for m in "${images[@]}";
	do 
		head=${m%.*}
		tail=${m##*.}
		convert $m -quality $1 $head'_'$1'rq.'$tail
		echo $m 'is compressed into' $head'_'$1'rq.'$tail
	done
}
function resolvingPower()
{
	jpgs=($(find "$2" -regex '.*\.jpg\|.*\.svg\|.*\.png'))
	for i in "${jpgs[@]}";
	do 
		head=${i%.*}
		tail=${i##*.}
		convert $i -resize $1 $head'_'$1'rp.'$tail
		echo $i 'is compressed into ' $head'_'$1'rp.'$tail	

	done
}
function watermark()
{
	images=($(find "$2" -regex '.*\.jpg\|.*\.svg\|.*\.png\|.*\.jpeg'))
	for m in "${images[@]}";
	do 
		head=${m%.*}
		tail=${m##*.}
		convert $m -gravity south -fill black -pointsize 16 -draw "text 5,5 '$1'" $head'_wm.'$tail
		echo $m "is added watermark"
	done
}
function rename()
{
	images=($(find "$3" -regex '.*\.jpg\|.*\.svg\|.*\.png\|.*\.jpeg'))
	case "$1" in
		"head")
			for m in "${images[@]}";
			do
				direc=${m%/*}
				file_name=${m%.*}
				tail=${m##*.}
				head=${file_name##*/}
				mv $m $2$head'.'$tail
				echo "head is added"
			done
		;;
		"tail")
			for m in "${images[@]}";
			do
				x=$m
				head=${x%.*}
				tail=${x##*.}
				mv $m $head$2'.'$tail
				echo "tail is added"
			done
		;;
		esac
}
function transformat()
{
	images=($(find "$1" -regex '.*\.png\|.*svg'))
	for m in "${images[@]}";
	do 
		convert $m "${m%.*}.jpg"
		echo "transformation is done"
	done

}
while [ "$1" != "" ];do
case "$1" in 
	"-q")
		reduceQuality $2 $3
		exit 0
		;;

	"-p")
		resolvingPower $2 $3
		exit 0
		;;
	"-w")
		watermark $2 $3
		exit 0
		;;
	"-r")
		rename $2 $3 $4
		exit 0;
		;;
	"-t")
		transformat $2
		exit 0;
		;;
	"-h")
		help
		exit 0
		;;
	esac
done

