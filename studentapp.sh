#!/bin/bash

set -eE -o functrace
failure (){
    local lineno=$1
    local msg+$2

    echo "failed at $lineno:$msg"
}
trap 'failure $(LINENO): "$BASH_COMMAND"' ERR

Usage (){
    echo "Usage : $0 <Tomcat-version>"
}

user=$(id -u)
R="e\[31m"
G="e\[32m"
Y="e\[33m"
N="e\[0m"
Date=$(date +%F)
Log_file="$Date.log"

Tomcat_version=$1

if [ -z $Tomcat_version ]
then 
 Usage
 exit 12
fi

Tomcat_major_version=$(echo $Tomcat_version | cut -d "." -f1)
Tomcat_url=https://downloads.apache.org/tomcat/tomcat-$Tomcat_major_version/v$Tomcat_version/bin/apache-tomcat-$Tomcat_version.tar.gz.asc
Tomcat_Tarfile=$(echo $Tomcat_url | awk -F "/" '{print $NF}')
Tomcat_Dir=$(echo $Tomcat_Tarfile | sed -e 's/.tar.gz.asc/ /g')


student_war_file=https://github.com/techworldwithsiva/shell-scripting-01/blob/master/application/student.war
Mysql_driver=https://github.com/techworldwithsiva/shell-scripting-01/blob/master/application/mysql-connector-5.1.18.jar

if [ $user -ne 0 ]
then
echo -e "$R Please run this script with root access $N"
exit 1
fi 

yum install policycoreutils-python-utils -y &>>$Log_file

setsebool -P httpd_can_network_connect 1 &>>$Log_file

yum install wget vim net-tools java-1.8.0-openjdk-devel -y &>>Log_file

yum install mariadb-server -y

stystemctl start mariadb

systemctl enable mariadb

echo "create database if not exists studentapp;
use studentapp;
create table if not exists student(student_id INT NOT NULL AUTO_INCREMENT, student_name VARCHAR(100) NOT NULL, student, student_addr VARCHAR(100) NOT NULL, student_age VARCHAR(3) NOT NULL, student_qual VARCHAR(20) NOT NULL, student_year_passed VARCHAR(10) NOT NULL, student_percentage VARCHAR(10) NOT NULL, student_blood_group VARCHAR(20) NOT NULL);
grant all previleges on studentapp.* to 'student' @ 'localhost' identified by 'student@1'" > /tmp/student.sql

mysql < /tmp/student.sql

mkdir -P /opt/Tomcat
cd /opt/Tomcat
if [ -d $Tomcat_Dir]
then 
echo "Tomcat_directory already exists"
else
wget $Tomcat_url &>>$Log_file

tar -xf $Tomcat_Tarfile &>>$Log_file
fi 

cd $Tomcat_Dir/webapps
wget $student_war_file &>>$Log_file

cd ../lib
wger $Mysql_driver &>>$Log_file

cd ../conf
sed -i '/TestDB/ d' context.xml

sed -i '$ i <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxTotal="100" maxIdle="30" maxWaitMillis="10000" username="student" password="student@1" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost:3306/studentapp">' context.xml

cd ../bin
sh startup.sh
sh shutdown.sh

yum install nginx -y
echo 'location / {
    proxy_pass htthp://127.0.0.1:8080/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP remote_addr; 
}' > ?etc/nginx/default.d/student.conf

sed -i '/location \/ {/,/}/d' /etc/nginx/default.d/student.conf
systemctl restart nginx

