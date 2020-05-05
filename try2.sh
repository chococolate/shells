#!/bin/bash
function helps()
{
	echo "usage:[options][][]"
	echo "options :"
	echo "-a ages"
	echo "-p positions"
	echo "-n names"
	echo "-m max/min age"
	echo "-h"

}
function ageinfo()
{
	ages=$(awk -F "\t" '{ print $6 }' worldcupplayerinfo.tsv)
	count=0
	lw_20=0
	bt_20_30=0
	hg_30=0
	for age in $ages;
	do
		if [ "$age" != "Age" ] ; then
			count=`expr $count + 1`
			if [ $age -lt 20 ] ; then
				lw_20=`expr $lw_20 + 1 `
			elif [ $age -gt 30 ] ; then
				hg_30=`expr $hg_30 + 1`
			elif [ $age -ge 20 ] && [ $age -le 30 ] ; then
				bt_20_30=`expr $bt_20_30 + 1`
			fi
		fi
	done
	percent_20=`awk 'BEGIN{printf "%.3f\n",('${lw_20}'/'$count')*100}'`
	percent_20_30=`awk 'BEGIN{printf "%.3f\n",('${bt_20_30}'/'$count')*100}'`
	percent_30=`awk 'BEGIN{printf "%.3f\n",('${hg_30}'/'$count')*100}'`
	echo "the number of players under 20 is $lw_20,accounting for $percent_20%"
        echo "the number of players between 20 and 30 is $bt_20_30,accounting for $percent_20_30%"
	echo "the number of players above 30 is $hg_30,accounting for $percent_30%"
}
function positioninfo()
{
	position=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)
	Goalie=0
	Defender=0
	Midfielder=0
	Forward=0
	count=0
	for i in $position
	do
		if [ "$i" != "Position" ] ; then
			count=`expr $count + 1`
			if [ "$i" == "Goalie" ] ; then
				Goalie=`expr $Goalie + 1`
			fi
			if [ "$i" == "Defender" ] ; then
				Defender=`expr $Defender + 1`
			fi
			if [ "$i" == "Midfielder" ] ; then
				Midfielder=`expr $Midfielder + 1`
			fi
			if [ "$i" == "Forward" ] ; then 
				Forward=`expr $Forward + 1`
			fi
		fi
	done
	percent_G=`awk 'BEGIN{printf "%.3f\n",('${Goalie}'/'$count')*100}'`
	percent_D=`awk 'BEGIN{printf "%.3f\n",('${Defender}'/'$count')*100}'`
	percent_M=`awk 'BEGIN{printf "%.3f\n",('${Midfielder}'/'$count')*100}'`
	percent_F=`awk 'BEGIN{printf "%.3f\n",('${Forward}'/'$count')*100}'`
	echo There are $Goalie goalies,the percent of which is $percent_G%
	echo There are $Defender defenders,the percent of which is $percent_D%
	echo There are $Midfielder midfenders,the percent of which is $percent_M%
	echo There are $Forward forwards,the percent of which is $percent_F%



}
function nameinfo()
{
	name=$(awk -F "\t" '{ print length($9) }' worldcupplayerinfo.tsv)
	longest=0;
	shortest=10000;
	for i in $name;
	do 
		if [ "$i" != "Player" ] ; then
			if [ $longest -lt $i ] ; then
				longest=$i
			fi
			if [ $shortest -gt $i ] ; then
				shortest=$i
			fi
		fi
	done
	lname=$(awk -F '\t' '{if (length($9)=='$longest'){print $9}}' worldcupplayerinfo.tsv)
	sname=$(awk -F '\t' '{if (length($9)=='$shortest'){print $9}}' worldcupplayerinfo.tsv)
	echo the longest name :
	echo $lname
	
	echo the shortest name :
	echo $sname

}
function mnameinfo()
{
	age=$(awk -F "\t" '{ print $6 }' worldcupplayerinfo.tsv)
	maxage=0
	minage=200
	for i in $age
	do
		if [ "$i" != "Age" ] ; then
			if [ $maxage -lt $i ] ; then
				maxage=$i;
			fi
			if [ $minage -gt $i ] ; then
				minage=$i;
			fi
		fi
	done
	maxagen=$(awk -F '\t' '{if($6=='$maxage') {print $9}}' worldcupplayerinfo.tsv)
	minagen=$(awk -F '\t' '{if($6=='$minage') {print $9}}' worldcupplayerinfo.tsv)
	echo who is the youngest?
	echo " $maxagen,the age of who is $maxage"
	echo who is the oldest?
	echo " $minage,the age of who is $minage"

}


while [ "$1" != "" ]; do
	case $1 in 
		-a ) ageinfo
			exit
			;;
		-p ) positioninfo
			exit
			;;
		-n ) nameinfo
			exit
			;;
		-m ) mnameinfo
			exit
			;;
		-h ) helps
			exit
			;;
		esac
	done

