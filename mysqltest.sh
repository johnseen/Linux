#!/bin/bash
if [ `ss -tan| grep 3307 | wc -l` -gt 0 ]; then
    echo "mysql is runing"
else
    echo "mysql is notruning,pls check"
fi 
