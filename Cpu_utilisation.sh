#!/bin/bash
cpu_threshold=01
cpu_usage=$( top -bn2 | grep '%Cpu' | tail -1 | grep -P '(......|...)id,' 
message=""
while IFS= read line;
do
  usage=$(echo $line | awk  '{print (100-$8)}'))
    echo  "cpu usage : $usage"
    if [ $usage -ge $cpu_threshold ]
    then
     message+="High CPU utilisation : $usage%\n"
    fi
done <<< "$cpu_usage"
echo "message : $message"
#echo -e "$message" | mail -s "High CPU usage" jagadeeshjaga19@gmail.com     
  