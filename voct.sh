#!/bin/bash
# A tool for training vocabulary
# Script takes .txt file containing vocabulary as argument
# Vocabulary must contain lines in format:
# 'word/phrase in one language'-'that in other language'

# Argument: path to vucabulary text file
# Enter '!' to end the program
# Enter '?' to show the correct answer and go to next turn


# basic input argument checking (the vocabulary file)
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


# Next lines of code are for user interface formating
COLS=`tput cols`
ROWS=`tput lines`
tput bold #set bold font
formated_output()
{
    MESSAGE=$1
    INPUT_LENGTH=${#MESSAGE} #input had to be firs assigned to variable otherwise we would get number of arguments instead number of chars

    HALF_INPUT_LENGTH=$(( $INPUT_LENGTH / 2 ))
    ROW_POSITION=$(( $ROWS / 2 ))
    COL_POSITION=$(( $COLS / 2 - $HALF_INPUT_LENGTH ))

    tput clear #clear terminal
    tput cup $ROW_POSITION $COL_POSITION #cursor placement
    echo $MESSAGE #print there what we wanted
}
center_cursor()
{
    ROW_POSITION=$(( $ROWS / 2 + 1 ))
    COL_POSITION=$(( $COLS / 2 ))
    tput cup $ROW_POSITION $COL_POSITION #cursor placement    
}
time_to_die()
{
    tput sgr0 #turn off all the settings we just made
    tput cup `tput lines` 0 #place the prompt at the bottom of the screen
    exit 0
}

ANSWER=''
#main loop
until [ "$ANSWER" = '!' ]; do

    VOCDATA=`sed '/^$/d' $1` # strip the file of empty lines
    NLINES=`echo "$VOCDATA" | wc -l`

    # extracting needed data from the file
    LINEN=`shuf -i 1-$NLINES -n 1` # random line number
    VOCABULARY_LINE=`echo "$VOCDATA" | sed -n "$LINEN"p`
    COIN_TOSS=`shuf -i 1-2 -n 1`

    EXPECTING=`echo "$VOCABULARY_LINE" | awk -v pick=$COIN_TOSS -F[-] '{print $pick}'` # this is the correct answer
    case $COIN_TOSS in
	1)
	    ASKING=`echo "$VOCABULARY_LINE" | awk -F[-] '{print $2}'`
	    ;;
	2)
	    ASKING=`echo "$VOCABULARY_LINE" | awk -F[-] '{print $1}'`
	    ;;
	*)
	    formated_output "ERROR: Something went really wrong. 1>&2"
	    tput sgr0 #turn off all the settings we just made
	    tput cup `tput lines` 0 #place the prompt at the bottom of the screen
	    exit 1
	    ;;
    esac


    #loop for particular attempt - processing uder input and doing the logic
    COUNTER=2
    until [ "$ANSWER" = "$EXPECTING" ]; do
	
	if (( $COUNTER < 1 )); then
	    formated_output "Right Answer: $EXPECTING"
	    center_cursor
	    read BECKON # waiting for user input so he has time to read
	    if [ "$BECKON" = '!' ]; then
		time_to_die
	    fi
	    break
	fi

	if (( $COUNTER != 2 )); then
	    formated_output "Wrong entry (Translate: $ASKING)"
	else
	    formated_output "Translate: $ASKING"
	fi

	center_cursor
	read ANSWER
	
	if [ "$ANSWER" = '!' ]; then # i don't want to continue, deliberate end
	    time_to_die
	fi
	
	if [ "$ANSWER" = '?' ]; then # show me the right answer and go to next word
	    formated_output "Right Answer: $EXPECTING"
	    center_cursor
	    read BECKON # waiting for user input so he has time to read
	    if [ "$BECKON" = '!' ]; then
		time_to_die
	    fi
	    break
	fi
	
	(( COUNTER-- ))
    done

    
done

time_to_die
