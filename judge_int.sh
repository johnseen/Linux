#!/bin/bash
while true
do 
    read -p "please input:" a
    expr $a + 0 >/dev/null 2>&1
    [ $? -eq 0 ] && echo int || echo chars
done
