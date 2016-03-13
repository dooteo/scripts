#!/bin/bash
# Iñaki Larrañaga Murgoitio <dooteo@zundan.com>, 2016
# License: GPL v3

METAFLAC=`which metaflac`
if [ "${METAFLAC}" = "" ]; then
	echo "metaflac command not found. Please, install 'flac' package."
	echo "su -c \"apt-get -y install flac\""
	exit
fi

case $1 in
	"-l")
	echo -e "List of TAGS  for FLAC format\n-----------------------------
	TITLE
	ARTIST
	ALBUM
	COMMENT
	GENRE
	DISCNUMBER
	TRACKNUMBER
	DATE / YEAR
	ALBUM ARTIST / ALBUMARTIST / ENSEMBLE
	PUBLISHER
	COMPOSER
	BPM
	REPLAYGAIN_TRACK_GAIN
	REPLAYGAIN_TRACK_PEAK
	REPLAYGAIN_ALBUM_GAIN
	REPLAYGAIN_ALBUM_PEAK
	GRACENOTEFILEID
	GRACENOTEEXTDATA"
	exit;;
	"-h")
	echo "This Script set tags to flac formats songs
Usage: $0 [option]
Available options:
	-l		List tags supported by FLAC format and quits
	-h 		Shows this help and quits.
"
	exit;;
esac
if [ "$1" == "-l" ]; then
fi

echo "Enter Artist name"
read ARTIST
if [ "${ARTIST}" = "" ]; then
	echo "ARTIST field empty. Bye!"
	exit
fi

echo "Enter Album name"
read ALBUM
if [ "${ALBUM}" = "" ]; then
	echo "ALBUM field empty. Bye!"
	exit
fi

echo "Enter Year"
read YEAR
if [ "${YEAR}" = "" ]; then
	echo "YEAR field empty. Bye!"
	exit
fi
# Check Year is numeric with Reg Expression
NUMERIC_RE='^[0-9]+$'
if ! [[ $YEAR =~ $NUMERIC_RE ]]; then
	echo "Error. YEAR is not numeric."
	echo "Setting it as empty date"
	YEAR=""
fi

echo "Enter Genre"
read GENRE

echo "Enter general comment"
read COMMENT
ITEM_COMMENT=${COMMENT}

find -type f -name '* *' | rename 's/ /_/g'

for item in `ls *flac`; do
	getname=`echo ${item} | rev | cut -d'.' -f2- | rev`
	name=`echo ${getname} | cut -d'.' -f2 | sed -e 's/-//g' -e 's/_/ /g'`
	number=`echo ${getname} | cut -d'.' -f1 `
	echo "Next track info: $number $name. Is it okey? (Y/n)"
	read answer

	if [ "${anser}" != "" ]; then
		echo "Enter track number"
		read number
		echo "Enter track name" 
		read name
	fi
	
	
	if [ "${COMMENT}" = "" ]; then
		echo "Some comment for this track? (default: empty) "
		read ITEM_COMMENT
	fi

	${METAFLAC} --remove-all-tags --set-tag=ARTIST="${ARTIST}" \
		--set-tag=ALBUM="${ALBUM}" --set-tag=GENRE="${GENRE}" \
		--set-tag=DATE="${YEAR}" --set-tag=TRACKNUMBER="${number}" \
		--set-tag=TITLE="${name}" --set-tag=COMMENT="${ITEM_COMMENT}" \
		${item}

done

