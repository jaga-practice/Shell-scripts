#!/bin/bash
Directory=/c/Users/jagadeesh/desktop/logs
Date=$(date + "%F-%H-%M-%S")
Log_file="$Date.log"
Input=$(find /c/Users/jagadeesh/desktop/logs -name "*.log" -type f mtime +14)
while IFS=read -r line
do 
echo "Deleting logfile : $line" &>>Log_file
#rm -rf $line
done <<< "$Input"