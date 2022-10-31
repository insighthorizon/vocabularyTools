#!/bin/bash
if [ ! -e $1 ]; then
    echo Source file ERROR: Wrong path, file doesn\'t exist. 1>&2
    exit 1
else
    if [ -d $1 ]; then
	echo Source file ERROR: Wrong path, this is directory. 1>&2
	exit 1
    else
	if [ ! -s $1 ]; then
	    echo Source file ERROR: The file is empty. 1>&2
	    exit 1
	fi
    fi
fi


#get rid of the info lines, cut out empty lines, turn all uppercase to lowercase
LIST=`sed -n '/========= OLD ITEMS: ===========/q;p' $1 | sed '/^$/d' |  tr '[:upper:]' '[:lower:]'`
#LIST=`sed '/^$/d' $1`
#LIST=`echo "$LIST" | tr '[:upper:]' '[:lower:]'`
#write the adjustments into the file right away
echo "$LIST" > $1
    
exit 0
