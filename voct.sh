#!/bin/bash
# A tool for training vocabulary
# Script takes .txt file containing vocabulary as argument
# Vocabulary must contain lines in format:
# 'word/phrase in one language'-'that in other language' - phrases can contain anything but a dash (-) or newline (\n)

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

# debug testing
#formated_output "$NLINES ... |${COUNTanswers[0]}| |${COUNTanswers[1]}| |${COUNTanswers[2]}| |${COUNTanswers[3]}|"

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


WALL=3 #number of items in vocabulary will not go bellow this value - WALL of the last items will have to be killed at once
THICK=2 #number of consecutive valid answers needed to complete the item
THICK_1=$(( $THICK - 1 ))

# initialise the vocabulary
VOCDATA=`sed '/^$/d' $1` # strip the file of empty lines
NLINES=`echo "$VOCDATA" | wc -l`
for i in $(seq 0 $(( $NLINES - 1 )) ); do
    COUNTanswers[i]=0
done


ANSWER=''
#main loop
while true; do
    # extracting needed data from the file
    LINEN=`echo "$(od -An -N4 -tu4 /dev/urandom) % $NLINES + 1" | bc` # random line number
    VOCABULARY_LINE=`echo "$VOCDATA" | sed -n "$LINEN"p`
    COIN_TOSS=`echo "$(od -An -N4 -tu4 /dev/urandom) % 2 + 1" | bc`

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


    #loop for particular attempt - processing user input and doing the logic
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


    if [ "$ANSWER" = "$EXPECTING" ]; then
	(( COUNTanswers[(( $LINEN - 1 ))]++ ))
	if (( ${COUNTanswers[(( $LINEN - 1 ))]} > $THICK_1 )); then
	    if (( $NLINES > $WALL )); then # remove item from vocabulary only if there are still more than 2 items
		unset 'COUNTanswers[(( $LINEN - 1 ))]' # remove the item froum array of counts of anwers
		COUNTanswers=("${COUNTanswers[@]}")
		VOCDATA=`echo "$VOCDATA" | sed "$LINEN"d` # remove the item from vocabulary
		NLINES=`echo "$VOCDATA" | wc -l` # recount the number of lines
	    else
		for i in $(seq 0 $(( $WALL - 1 )) ); do
		    if (( ${COUNTanswers[i]} < $THICK )); then
			break
		    fi
		    if [ $i -eq $(( $WALL - 1)) ]; then # check for game over
			formated_output "Finished! You did it :-)"
			read BECKON # waiting for user input so he has time to read	
			time_to_die
	 	    fi
		done
	    fi
	fi
    else
	COUNTanswers[(( $LINEN - 1 ))]=0 #failed answer resets counter of good answers

    fi

# debug testing	    
#    for i in $(seq 0 $(( $NLINES - 1)) ); do
#	VOCABULARY_LINE=`echo "$VOCDATA" | sed -n "$(( i + 1 ))"p`
#	echo "$VOCABULARY_LINE ... ${COUNTanswers[i]}"
#    done
#    read BECKON

    
    ANSWER=''    
done


time_to_die
