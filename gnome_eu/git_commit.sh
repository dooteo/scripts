#!/bin/bash

if [ "$1" = "-h" ]; then
	echo -e "\n\tThis tool commit eu.po into local repository"
	echo -e "\tand pushes changes into remote git.gnome.org repository\n"
	exit 0
fi

# Delete previously created *mo and *pot files
rm -f messages.mo *pot eu[0-9].po

WHICH_BRANCH=`git branch | grep "^*" | cut -d" " -f2`
echo -e "\n\n ---- Commit eu.po file for Branch ${WHICH_BRANCH} -----\n\n"

git add eu.po
git commit eu.po -m "Updated Basque language" --author "Inaki Larranaga Murgoitio <dooteo@zundan.com>"
git push origin ${WHICH_BRANCH}

