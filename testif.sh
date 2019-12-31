#!/bin/bash
read -p "pls input two num:" a b
if [ $a -lt $b ];then
    echo "yes,$a less than $b"
elif [ $a -eq $b ];then
    echo "no ,$a is not less than $b"
else
    echo "can not acc"
fi
