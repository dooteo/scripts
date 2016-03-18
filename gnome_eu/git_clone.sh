#!/bin/bash

if [ -z $1 ]; then 
	echo -e "\n\Usage: $0 module [branch]\n"
	echo -e "This Script fetches a module from GNOME's Git repository,\n"
	echo -e "or updates in local previously fetched one.\n"
	exit 1
fi

GNOME_MODULE="${1}"

GITBIN=`which git`

if [ "${GITBIN}" == "" ]; then 
	echo -e "GIT tools not installed.\nDo you know what should you do?\n";
	echo -e "\t apt-get install git-core"
	exit 1;
fi

export GNOME_GIT_DIR="${HOME}/Projects/l10n/git-gnome"

if [ ! -d "${GNOME_GIT_DIR}" ]; then
	mkdir -p ${GNOME_GIT_DIR} ;
fi

cd $GNOME_GIT_DIR ;

if [ ! -d ${GNOME_GIT_DIR}/${GNOME_MODULE} ]; then
	git clone ssh://dooteo@git.gnome.org/git/${GNOME_MODULE} ;

	if [ ! -d ${GNOME_MODULE} ]; then
		echo -e "\n\Error to run GIT Clone."
		echo -e "\n\Is module's name properly entered?"
		echo -e "\n\t\t${GNOME_MODULE}"
		exit 1
	else
		cd ${GNOME_MODULE} ;
	fi

else
	cd ${GNOME_MODULE} ;
	git fetch
	git pull --rebase
fi

cd po/

