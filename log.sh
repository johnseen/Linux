#!/bin/bash 
 find /opt/kjsoft/kjapp/dotnet/git/publish/ -depth -name txt* -mtime -3 -exec rm -rf {} \;
 
