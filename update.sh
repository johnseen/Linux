#!/bin/bash
a=$1
b=$2

if [ $# -ne 2 ];then 
    echo "mush be two args"
    echo "usage: $0 args1 args2"
    exit 2
fi

expr $a + 1 &>/dev/null 
RETVAL1=$?

expr $b + 1 &>/dev/null 
RETVAL2=$?

if [ $RETVAL1 -ne 0 -a $RETVAL2 -ne 0 ];then
    echo "pls input two int args"
    exit 3
fi

if [ $a -lt $b ];then
    echo "$a is less than $b"
elif [ $a -eq $b ];then
    echo "$a equal $b"
else
    echo "$a gt $b"
fi
