#!/bin/bash
for i in `ls /github/scripts/SQLT/ |grep '^1'|awk -F . {'print $1'} |sort -nr|cut -b 1-5`
do
    if [ $i -gt 10200 ];then
        echo $i.sql
    fi
done
