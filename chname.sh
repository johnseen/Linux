#!/bin/bash
cd /scripts
for i in `ls | grep "txt$"`
do
    mv $i `echo $i |cut -d . -f1`.gif
done
