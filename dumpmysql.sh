#!/bin/bash
MYSQLHOST=192.168.100.117
MYSQLPASSWD=123456
MYSQLPORT=3307
MYSQLUSER=root
MYSQLCMD="mysql  -h $MYSQLHOST -u $MYSQLUSER -P$MYSQLPORT -p$MYSQLPASSWD"
MYSQLDUMP="mysqldump -h $MYSQLHOST -u $MYSQLUSER -P$MYSQLPORT -p$MYSQLPASSWD"
DBPATH="/tmp/backup"
[ ! -d "$DBPATH" ] && mkdir $DBPATH 
for dbname in `echo "show databases"|$MYSQLCMD|egrep -v "Database|_schema$|sys|mysql"`
do 
    $MYSQLDUMP $dbname | gzip >$DBPATH/${dbname}_$(date +%F).sql.gz
done
