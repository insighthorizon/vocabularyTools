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
    array=(pluto pippo bob)
    printf "${array[0]}\n"
    printf "${array[1]}\n"
    unset 'array[0]'
    array=("${array[@]}")
    printf "${array[0]}\n"
    printf "${array[1]}\n"


    for i in $(seq 0 $(( $NLINES - 1 )) ); do
	COUNT_ARR[i]=3
	printf "${COUNT_ARR[i]}\n"
    done
    COUNT_ARR[0]=$(( ${COUNT_ARR[0]} + 10 ))
    printf "${COUNT_ARR[0]}\n"
    
    
    LINEN=`echo "$(od -An -N4 -tu4 /dev/urandom) % $NLINES + 1" | bc` # random line number    
    VOCABULARY_LINE=`echo "$VOCDATA" | sed -n "$LINEN"p`
    VOCDATA=`printf "$VOCDATA" | sed "/$VOCABULARY_LINE/d"`
    echo "$VOCDATA"
    echo "$VOCDATA" | wc -l
    if [ "$VOCDATA"  == '' ]; then
	echo "finished"
	exit 0
    fi
    printf "\n"

    NLINES=`echo "$VOCDATA" | wc -l`
    LINEN=`echo "$(od -An -N4 -tu4 /dev/urandom) % $NLINES + 1" | bc` # random line number    
    VOCABULARY_LINE=`echo "$VOCDATA" | sed -n "$LINEN"p`
    VOCDATA=`printf "$VOCDATA" | sed "/$VOCABULARY_LINE/d"`
    echo "$VOCDATA"
    echo "$VOCDATA" | wc -l    
    if [ "$VOCDATA"  == '' ]; then
	echo "finished"
	exit 0
    fi
    printf "\n"
    
    NLINES=`echo "$VOCDATA" | wc -l`
    LINEN=`echo "$(od -An -N4 -tu4 /dev/urandom) % $NLINES + 1" | bc` # random line number    
    VOCABULARY_LINE=`echo "$VOCDATA" | sed -n "$LINEN"p`
    VOCDATA=`printf "$VOCDATA" | sed "/$VOCABULARY_LINE/d"`
    echo "$VOCDATA"
    echo "$VOCDATA" | wc -l
    if [ "$VOCDATA"  == '' ]; then
	echo "finished"
	exit 0
    fi

    
exit 0
