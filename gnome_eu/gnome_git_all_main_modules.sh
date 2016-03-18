#!/bin/bash

TEAM="eu"
DOWNLOAD_DIR="${HOME}/Deskargak"
echo -e " ---- GNOME 3.xx ---- \nWhich branch? [20]"
read version
if [ "${version}" = "" ]; then
	GNOME_VERSION="3-20"
else 
	GNOME_VERSION="3-${version}"
fi

SRC=vertimus

wget -c https://l10n.gnome.org/languages/${TEAM}/gnome-${GNOME_VERSION}/ui/ -O ${DOWNLOAD_DIR}/gnome_${GNOME_VERSION}.html

for i in `cat ${DOWNLOAD_DIR}/gnome_${GNOME_VERSION}.html | grep vertimus | awk '{print $2}'`; do 
	module=`echo $i | cut -d"/" -f3`; 
	branch=`echo $i| cut -d"/" -f4`; 
	echo $module $branch; 
	git_clone.sh $module;
	echo -e "---- ${module} downloaded ----\n\n"
done

# Remove downloaded HTML file.
rm -f ${DOWNLOAD_DIR}/gnome_${GNOME_VERSION}.html
