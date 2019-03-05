#!/bin/bash
# A tool to quickly search if a list of items is already in the vocabulary
# run with one argument: path to the list text file
LIST=`sed '/^$/d' $1`
NLINES=`echo "$LIST" | wc -l`
NEW_ITEMS=''
OLD_ITEMS=''
for i in $(seq 1 $NLINES); do
    ITEM=`echo "$LIST" | sed -n "$i"p`
    ITEM_INFO=`grep -nr -i --include="voc_En*\.txt" "$ITEM"`
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

