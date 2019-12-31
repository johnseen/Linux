#!/bin/bash
mysql -h 192.168.100.234 -u quantum -pscmadmin -e"use scmwms;select * from sys_upgrade_history WHERE UPGRADE_TYPE='Normal' ORDER BY version_no DESC" >/tmp/list2
result=`awk {'print $3'} /tmp/list2 |sort -nr | head -n 1 `
echo $result

