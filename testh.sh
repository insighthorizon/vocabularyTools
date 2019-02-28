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




    VOCDATA=`sed '/^$/d' $1` # strip the file of empty lines
    NLINES=`echo "$VOCDATA" | wc -l`
    array[1]=2
    array[2]=2
#    echo "${array[0]}\n"
#    echo "${array[1]}\n"
#    unset 'array[0]'
    array=("${array[@]}")
    echo "${array[0]}"
    echo "${array[1]}"

    LINEN=1
    (( array[(( $LINEN -1 ))]++ ))
    echo "${array[0]}"
    echo "${array[1]}"


    for i in $(seq 0 $(( $NLINES - 1 )) ); do
	COUNT_ARR[i]=3
	echo "${COUNT_ARR[i]}"
    done
    COUNT_ARR[0]=$(( ${COUNT_ARR[0]} + 10 ))
    echo "${COUNT_ARR[0]}\n"
    
    LINEN=`echo "$(od -An -N4 -tu4 /dev/urandom) % $NLINES + 1" | bc` # random line number
    VOCABULARY_LINE=`echo "$VOCDATA" | sed -n "$LINEN"p`
    VOCDATA=`echo "$VOCDATA" | sed "/$VOCABULARY_LINE/d"`
    echo "$VOCDATA"
    echo "$VOCDATA" | wc -l
    if [ "$VOCDATA"  == '' ]; then
	echo "finished"
	exit 0
    fi
    printf "\n"

#    pole[0]=0
    pole[1]=1
#    pole[2]=0
    pole[3]=1
#    pole[5]=0

    pole=("${pole[@]}")

    echo "|${pole[0]}| |${pole[1]}| |${pole[2]}| |${pole[3]}| |${pole[4]}|"
    
exit 0
