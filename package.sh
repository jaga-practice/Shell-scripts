#!/bin/bash
user=$(id -u)
Date=$(date + "%F-%H-%M-%S")
Log_file="$Date.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
W="\e[0m"
if [ $user -ne 0 ]
then
echo "$R Please run the script with root access $W"
exit 1
fi
Validate ()
{
if [ $1 -ne 0 ]
then 
echo -e "$2... $R installation failed $W"
exit 1
else 
echo -e "$2...$G installed successfully $W"
fi
}
for Package in $@
do 
yum -q list installed $Package &>/dev/null

if [ $? -ne 0 ]
then
echo "$Package...not installed"
yum install $Package -y &>>Log_file
Validate $? "$Package installation"
else 
echo -e "$Package...$Y already installed $w"
fi 
done
