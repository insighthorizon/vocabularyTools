# vocabularyTools

A tool for learning vocabulary in Linux command line. Programs ask the user to translate the words displayed on the screen. The words are in a simple text file and the text file is argument of the program while calling it from command line.

Make your own vocabulry file with name prefix voc and postfix .txt (voc*.txt) in the following format:
word1language1-word1language2
word2language1-word2language2
word1language1-word3language2
...

Running in terminal:

$ ./voct.sh ./voc_En1.txt


Run to check if items in list are already in vocabulary:

$ ./checker.sh ./list.txt 