#!/bin/bash

echo -e "
\n\tThis script is used to commit LINGUAS and eu.po file,  
when eu.po file is brand new created and you entered a line 'eu' into LINGUAS file. 
"

# Delete previously created *mo and *pot files
rm -f messages.mo *pot eu[0-9].po

git add eu.po
git status

LINGUASFILE=""
LINGUASMESSAGE=""
if [ -f "LINGUAS" ] ; then
	LINGUASFILE="LINGUAS"
	LINGUASMESSAGE="\nAdded 'eu' (Basque) to LINGUAS"
fi

git commit eu.po ${LINGUASFILE} -m "Added Basque language${LINGUASMESSAGE}" --author "Inaki Larranaga Murgoitio <dooteo@zundan.com>"
git push origin master

