#!/bin/bash

echo -e "\n\tThis tool add and commit eu.po into local repository"
echo -e "\tand pushes changes into remote git.gnome.org repository\n"

# Delete previously created *mo and *pot files
rm -f messages.mo *pot


WHICH_BRANCH=`git branch | grep "^*" | cut -d" " -f2`

git add eu.po
git add LINGUAS
echo -e "\n\n ---- Commit LINGUAS and eu.po files for Branch ${WHICH_BRANCH} -----\n\n"

git commit eu.po LINGUAS -m "Updated Basque language" --author "Inaki Larranaga Murgoitio <dooteo@zundan.com>"
git push origin ${WHICH_BRANCH}
