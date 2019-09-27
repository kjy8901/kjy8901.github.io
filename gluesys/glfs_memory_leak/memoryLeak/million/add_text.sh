#!/bin/bash

files=( 0million.pl 1million.pl 2million.pl 3million.pl 4million.pl 5million.pl 6million.pl 7million.pl 8million.pl 9million.pl )
for i in ${files[*]}
do
    echo $i
    perl -p -i -e '$.==16 and print "asdfasdf"' $i
done
