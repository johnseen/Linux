#!/bin/bash
for i in {1..32767}
do
    echo "`echo $i|md5sum` $i" >>/tmp/md5sum5.txt
done
