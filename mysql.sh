#!/bin/bash
MYSQLUSER=root
MYSQLPASSWD=123456
MYSQLHOST=192.168.100.117
MYSQLPORT=3307
MYSQLCMD="mysql -h $MYSQLHOST -u $MYSQLUSER -P$MYSQLPORT -p$MYSQLPASSWD"
for dbname in deku1 deku2 deku3
do
    $MYSQLCMD -e "create database $dbname CHARACTER SET utf8 COLLATE utf8_general_ci"
done
