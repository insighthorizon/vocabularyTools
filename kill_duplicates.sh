#!/bin/bash

NEW_VERSION=`awk '!a[$0]++' $1`
echo "$NEW_VERSION" > $1

# sort prep.txt | uniq -cd
