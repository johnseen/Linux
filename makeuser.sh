#!/bin/bash
. /etc/init.d/functions 
user="deku"
passf=/tmp/usr.log
for num in `seq -w 10`
do 
    useradd $user$num &>/dev/null &&\ 
    pass="`echo $RANDOM|md5sum|cut -c1-8`"
    echo "$pass" |passwd --stdin $user$num &>/dev/null &&\
    echo -e "user:$user$num\tpasswd:$pass">>$passf
    if [ $? -eq 0 ];then
        action "$user$num is ok"   /bin/true 
    else
        action "$user$num is fail" /bin/false 
    fi
done
cat $passf
