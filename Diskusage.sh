#!/bin/bash
Diskthreshold=1
Diskusage=$(df -hT | grep -vE 'tmpfs|Filesystem' | awk '{print $6 " " $1}')
message=""

while IFS= read line
do 
  usage=$(echo $line | cut -d "%" -f1)
  partition=$(echo $line | cut -d " " -f2)
  echo "usage : $usage"
  echo "partition : $partition"
    if [ $usage -ge $Diskthreshold ]
     then
     message+="High Disk usage on $partition : $usage%\n "
     fi 
done <<< "$Diskusage"
echo "message: $message"
#echo -e "$messsage" | mail -s "High disk usage" jagadeeshjaga19@gmail.com   

#sh mail.sh jagadeeshjaga18@gmail.com "High Disk usage" "$message" "Devops Team"