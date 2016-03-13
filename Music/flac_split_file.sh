#!/bin/bash
# Iñaki Larrañaga Murgoitio <dooteo@zundan.com>, 2016
# License: GPL v3

WHICH_SHNTOOL=`which shntool`
if [ "${WHICH_SHNTOOL}" = "" ]; then
	echo "install shntool and cuetools package first! You know (as root):"
	echo "apt-get -y install shntool cuetools"
	exit
fi

if [ "$1" = "-h" ]; then
	echo "This Script reads a CUE file to split a big size FLAC into several tracks.
Usage: $0 [option]
Available options:
	-h 		Shows this help and quits.
"
	exit
fi

CUE_FILE=`ls *.cue`
if [ "${CUE_FILE}" == "" ]; then
	echo "No CUE file found. Nothing to do. Bye!"
	exit
fi

NEW_CUE_FILE=`echo ${CUE_FILE} | sed 's/ /_/g'`
if [ ! -f ${NEW_CUE_FILE} ]; then
	mv "${CUE_FILE}" ${NEW_CUE_FILE}
fi

PATH_CUE=`grep FILE ${NEW_CUE_FILE}`

TYPE_IN_CUE=`echo ${PATH_CUE} | cut -d'"' -f2 | cut -d'.' -f2`
echo "Music file type from CUE: ${TYPE_IN_CUE}"

# ---- Check 'mac' is installed for APE type file ! ----
if [ "${TYPE_IN_CUE}" == "ape" ] && [ ! -f "/usr/bin/mac" ]; then
	echo "install Monkey's Audio codec first! You know (as root):"
	echo " apt-get -y install monkeys-audio"
	exit
fi

NEW_PATH_CUE=`echo ${PATH_CUE}  | cut -d'"' -f2 | sed 's/ /_/g'`

sed -i -E 's/(FILE\s\").*(\"\s)/\1'${NEW_PATH_CUE}'\2/g' ${NEW_CUE_FILE}


MUSIC_FILE=`find ./ -type f -iname "*.${TYPE_IN_CUE}"`
if [ "${MUSIC_FILE}" == "" ]; then
	echo "No ${MUSIC_FILE} type file found. Nothing to do. Bye!"
	exit
fi


NEW_MUSIC_FILE=`echo ${MUSIC_FILE} | sed 's/ /_/g'`
if [ ! -f ${NEW_MUSIC_FILE} ]; then
	mv "${MUSIC_FILE}" ${NEW_MUSIC_FILE}
fi

${WHICH_SHNTOOL} split -f ${NEW_CUE_FILE} -o 'flac flac  --output-name=%f -' -t '%n-%p-%t' ${NEW_MUSIC_FILE}

# Note: convert DTS to FLAC with ffmpeg. For example: 
#
# 	ffmpeg -ac 2 -i GusGus\ -\ Arabian\ Horse.wav.dts popo.flac
#
# where '-ac 2' means convert to stereo!
