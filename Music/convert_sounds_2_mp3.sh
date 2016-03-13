#!/bin/bash
# Iñaki Larrañaga Murgoitio <dooteo@zundan.com>, 2016
# License: GPL v3

WHICH_FFMPEG=`which ffmpeg`
if [ "${WHICH_FFMPEG}" = "" ]; then
	echo "install ffmpeg package first! You know (as root):"
	echo "su -c \"apt-get -y install ffmpeg\""
	exit
fi


if [ "$1" = "-h" ]; then
	echo "Converts all OGG and FLAC audio files founded into MP3 format.
Usage: $0 [option]
Available options:
	-h 		Shows this help and quits.
"
	exit
fi

echo ""

SAVEIFS=${IFS}
IFS=$(echo -en "\n\b")
MP3_quality='320'
INFMT='flac'

for i in `find ./ -type f -iname '*${INFMT}' `; do 
	echo $i;  
	indir=`dirname ${i} `; 
	track=`basename ${i} | sed 's/\.${INFMT}/\.mp3/g'`;   
	${WHICH_FFMPEG} -i ${i} -acodec libmp3lame -ab ${MP3_quality}k "${indir}/${track}"; 
done

INFMT='ogg'
for i in `find ./ -type f -iname '*${INFMT}' `; do 
	echo $i;  
	indir=`dirname ${i} `; 
	track=`basename ${i} | sed 's/\.${INFMT}/\.mp3/g'`;   
	${WHICH_FFMPEG} -i ${i} -acodec libmp3lame -ab ${MP3_quality}k "${indir}/${track}"; 
done
