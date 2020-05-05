#!/bin/bash

function helps(){
	echo "usage:[options][]"
	echo "option:"
	echo "-a"
	echo "-b"
	echo "-c"
	echo "-d"
	echo "-e 4xx"
	echo "-u [url]"
	echo "-h"
}
function top100_host()
{
	echo "show_top100_host and how much times" 
	awk '{m[$1]++;} END {for(i in m){print m[i],i;}}' ./web_log.tsv | sort -t " " -k 1 -n -r | head -n 100 


}
function top100_ip()
{
	echo "show_top_100_ip and how much times"
	awk -F '\t' '{m[$1]++} END {for(i in m){print m[i],i;}}' ./web_log.tsv | egrep "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}" | sort -n -r -k 1 |head -n 100

}
function top100_url()
{
	awk -F '\t' '{m[$5]++} END {for(i in m) {print m[i],i;}}' ./web_log.tsv | sort -n -r -k 1 |head -n 100
}
function Scode_time_percent()
{
	sed -e '1d' ./web_log.tsv| awk -F '\t' '{m[$6]++;b++} END {for(i in m) {print i,m[i],m[i]/b*100 "%"}}' | column -t

}
function Scode4xxtop10_url_time()
{
	echo 403
	awk -F '\t' '{if($6=="403") {m[$5]++}} END{for (i in m) {print m[i],i}}' ./web_log.tsv | sort -n -r -k 1 | head -n 10
	echo 404
	awk -F '\t' '{if($6=="404") {m[$5]++}} END{for (i in m) {print m[i],i}}' ./web_log.tsv | sort -n -r -k 1 | head -n 10

}
function top100_seturl()
{
	echo Input URL is $1
	url=$1
	awk -F '\t' '{if($5=="'"${url}"'") {m[$1]++}} END {for(i in m) {print m[i],i;}}' ./web_log.tsv |sort -n -r -k 1 |head -n 10
}

while [ "$1" != "" ]; do
	case $1 in
		-a ) top100_host
			exit
			;;
		-b ) top100_ip
			exit
			;;
		-c ) top100_url
			exit
			;;
		-d ) Scode_time_percent
			exit
			;;
		-e ) Scode4xxtop10_url_time
			exit
			;;
		-u ) top100_seturl $2
			exit
			;;
		-h ) helps
			exit
			;;

	esac
done
