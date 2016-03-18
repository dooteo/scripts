#!/bin/bash

echo -e "\n\tThis tool commit eu.po into local repository"
echo -e "\tand pushes changes into remote git.gnome.org repository\n"

# Delete previously created *mo and *pot files
rm -f messages.mo *pot eu[0-9].po

git add eu.po
git commit eu.po -m "Updated Basque language" --author "Inaki Larranaga Murgoitio <dooteo@zundan.com>"
git push origin master

