#!/bin/bash
md5char="4fe8bf20ed"
for line in `cat /tmp/md5sum5.txt`
do
if [ `echo $line | grep -w $md5char |wc -l` -eq 1 ];then
    echo $line
    break
fi
done
