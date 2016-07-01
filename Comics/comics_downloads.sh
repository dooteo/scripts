#!/bin/bash

WEBSITE="http://www.mangareader.net"
WEBDIR="${HOME}/mangareader"
WEBDIR_TMP="${WEBDIR}/tmp"
DEFAULT_SECTION="one-piece"
CURL_PATH=`which curl`

if [ "${CURL_PATH}" == "" ]; then
	echo "CURL not installed. Please run next command as root"
	echo "apt-get -y install curl"
	exit
fi

echo "Select comic you want ot fetch"
echo "
 1 - One Piece
 2 - Dr Slump
 3 - Dragon Ball
 4 - One Punch Man
 5 - Akira

 Other ones wont download anything.

"
read comic

if [ "${comic}" == "" ];then
	echo "No comic selected. Bye!"
	exit
fi

case $comic in
1)
	SECTION="${DEFAULT_SECTION}"
	COMIC_NAME="One Piece"
	;;
2)
	SECTION="dr-slump"
	COMIC_NAME="Dr Slump"
	;;
3)
	SECTION="dragon-ball"
	COMIC_NAME="Dragon Ball"
	;;
4)
	SECTION="onepunch-man"
	COMIC_NAME="One Punch Man"
	;;
5)
	SECTION="akira"
	COMIC_NAME="AKIRA"
	;;
*)
	echo "Unknown comic selected. Bye!"	
	exit
esac

WEBDIR_SECTION="${WEBDIR}/${SECTION}"
WEBHREF="<a href=\"/${SECTION}/"

# --------------------- FUNCTIONS ----------------
# download_chapter:
#	$1 --> chapter number from chapters.list
#	$2 --> chapter number as 00xx to create directory
function download_chapter {
	echo -e "---- ${SECTION} Chapter $2 ----\n"
	mkdir -p ${WEBDIR_SECTION}/${SECTION}_${2}
	curl -o chapter_${1}.html "${WEBSITE}/${SECTION}/$1"
	cat chapter_${1}.html | grep -e "^<option" | cut -d ">" -f1 | cut -d"/" -f 4 | sed 's/"//g' > chapter_${1}.txt
	last_chapter=`tail -n 1 chapter_${1}.txt`

	for ((i=1; i<=$last_chapter; i++)) do

		if [ ${i} -gt 1000 ];then
			pg_number=${i}
		elif [ ${i} -lt 10 ];then
			pg_number="000${i}"
		elif [ ${i} -lt 100 ];then
			pg_number="00${i}"
		else 
			pg_number="0${i}"
		fi

		echo -e "---- pg ${i}\n"
		curl -o chapter_${1}_${pg_number}.html "${WEBSITE}/${SECTION}/$1/${i}"


		image=`cat chapter_${1}_${pg_number}.html | grep "id=\"img\"" | cut -d":" -f2 | cut -d"\"" -f1`
		filename=$(basename "${image}")
		extension="${filename##*.}"

		echo -e "---- ---- img: ${pg_number}  http:${image}\n"
		echo -e " ---- ---- target: ${WEBDIR_SECTION}/${1}/${pg_number}.${extension}\n" 
		curl  --fail --silent --show-error -o ${WEBDIR_SECTION}/${SECTION}_${2}/${pg_number}.${extension} "http:${image}" 2> error_${1}.txt
		echo -e " ---- ---- Delete: chapter_${1}_${pg_number}.* ---- ---- "
		#rm -f chapter_${1}_${pg_number}.*
	done

	rm -f chapter_${1}*.* 

}



# --------------------- MAIN  ----------------

if [ ! -d "${WEBDIR_SECTION}"  ]; then
	mkdir -p ${WEBDIR_SECTION}
fi

if [ ! -d "${WEBDIR_TMP}"  ]; then
	mkdir -p ${WEBDIR_TMP}
fi

rm -rf ${WEBDIR_TMP}/*

cd ${WEBDIR_TMP}

echo -e "You selected ${COMIC_NAME} comicbook.\n Do you want to download all of books, or just specific one?[0 == all]"
read comic_number

if [ "${comic_number}"  == "" ] || [ "${comic_number}" == "0" ]; then

	echo "${WEBSITE}/${SECTION}"
	curl -o ${SECTION}.html "${WEBSITE}/${SECTION}"

	cat ${SECTION}.html | grep "${WEBHREF}" | cut -d">" -f1 | cut -d"/" -f3 | sed 's/"//g' | sort | uniq > chapters.list
else
	echo "${comic_number}" > chapters.list
fi


while IFS='' read -r chapter || [[ -n "$chapter" ]]; do

	chap_number="" # Just to add $chapter into string

	if [ ${chapter} -ge 1000 ];then
		chap_number="${chap_number}${chapter}"
	elif [ ${chapter} -lt 10 ];then
		chap_number="000${chapter}"
	elif [ ${chapter} -lt 100 ];then
		chap_number="00${chapter}"
	else 
		chap_number="0${chapter}"
	fi

	if [ ! -d "${WEBDIR_SECTION}/${SECTION}_${chapter}" ] && \
		[ ! -f "${WEBDIR_SECTION}/${SECTION}_${chap_number}.cbz" ]; then
		echo "+++++++++++++++++ Pull chapter #${chap_number} down ++++++++++++++++++"
#		to call download_chapter() use:
# 		download_chapter 2 00XX ----> (where 2 comes from chapters.list, and 00XX is dir name to be create
		download_chapter ${chapter} ${chap_number}
		cd ${WEBDIR_SECTION}

		zip -r ${SECTION}_${chap_number}.cbz ${SECTION}_${chap_number}
		rm -rf ${SECTION}_${chap_number}
		cd ${WEBDIR_TMP}
		echo -e "Sleep for 1 sec to let HTTP server breath ---"
		sleep 1	
		clear
	else
		echo "Chapter ${SECTION}_${chap_number}.cbz exist. Going to next chapter..."
	fi

done < chapters.list

echo -e "\n---- DONE !----\n"

