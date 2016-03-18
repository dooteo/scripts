#!/bin/bash

if [ -z $1 ]; then 
	echo -e "\n\terabilera: $0 adarra\n"
	exit 1
fi

GNOME_MODULE="${1}";

git checkout $1
git branch

echo -e "
Open another terminal to translate this branch module.
Once it's done, come back to current terminal, and enter a key to resume."
echo -e "\Return to master branch?"
read response


echo -e "\tSet it as master branch for future updates"

git branch
git checkout master
git branch
