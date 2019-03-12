#!/bin/bash
# A tool to quickly search if a list of items is already in the vocabulary
# run with one argument: path to the list text file

#get rid of the info lines, cut out empty lines, turn all uppercase to lowercase
LIST=`sed -n '/========= OLD ITEMS: ===========/q;p' $1 | sed '/^$/d' |  tr '[:upper:]' '[:lower:]'`
echo "$LIST" > $1 #write the adjustments into the file right away

NLINES=`echo "$LIST" | wc -l`
NEW_ITEMS=''
OLD_ITEMS=''

for i in $(seq 1 $NLINES); do
    ITEM=`echo "$LIST" | sed -n "$i"p`
    ITEM_INFO=`grep -nr -i --include="voc_En*\.txt" "$ITEM"` #ignoring letter case, look in files with prefix voc_En and suffix .txt
    if [ "$ITEM_INFO" = '' ]; then
	NEW_ITEMS+="$ITEM"
	NEW_ITEMS+=$'\n'
    else
	OLD_ITEMS+="$ITEM_INFO"
	OLD_ITEMS+=$'\n'
    fi
done

echo "========= OLD ITEMS: ==========="
echo "$OLD_ITEMS"
echo "========= NEW ITEMS: ==========="
echo "$NEW_ITEMS"

echo "========= OLD ITEMS: ===========" >> $1
echo "$OLD_ITEMS" >> $1
echo "========= NEW ITEMS: ===========" >> $1
echo "$NEW_ITEMS" >> $1

exit 0

