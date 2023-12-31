#!/bin/bash
set -eE -o functrace

failure(){
    local lineno=$1
    local msg=$2
    echo failed at "$lineno : $msg"
}
trap 'failure $(LINENO) : "$BASH_COMMAND"' ERR

User=$(id -u)
R="e\[31m"
G="e\[32m"
N="e\[0m"

Log_file=Docker_installation.log

if [ $User -ne 0 ]
then
echo "$R Please run the script with root access $N"
exit 1
fi 

dnf update -y &>>$Log_file
echo -e "$G updates...installed $N"

dnf config-manager --add repo https://download.docker.com/linux/centos/docker-ce.repo &>>$Log_file
echo -e "$G Repo...added $N"

dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>>$Log_file
echo -e "$G Packages...installed $N"

systemctl start Docker &>>$Log_file
echo "$G Docker started $N"
 
systemctl enable Docker &>>$Log_file
echo "$G Docker enabled $N"

usermod -aG Docker centos

echo "Docker installation success. please logout and login again"