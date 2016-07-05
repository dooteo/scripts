#!/bin/bash

WHICH_FFMPEG=`which ffmpeg`
if [ "${WHICH_FFMPEG}" = "" ]; then
	echo "install ffmpeg  package first! You know (as root):"
	echo "apt-get -y install ffmpeg"
	exit
fi

if [ "$1" = "-h" ]; then
	echo "This Script converts an APE format file into FLAC file.
Usage: $0 [option]
Available options:
	-h 		Shows this help and quits.
"
	exit
fi

APE_FILE=`ls *.ape`
if [ "${APE_FILE}" == "" ]; then
	echo "No APE file found. Nothing to do. Bye!"
	exit
fi

NEW_APE_FILE=`echo ${APE_FILE} | sed 's/ /_/g'`
if [ ! -f ${NEW_APE_FILE} ]; then
	mv "${APE_FILE}" ${NEW_APE_FILE}
fi

FLAC_FILE=`echo ${APE_FILE} | sed 's/\.ape/\.flac/g'`

${WHICH_FFMPEG} -i ${APE_FILE} ${FLAC_FILE}

