#!/bin/bash
for i in `cat /etc/passwd |grep ^deku|awk -F : '{print $1}'`
do
    userdel $i
done
