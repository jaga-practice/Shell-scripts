#!/bin/bash
set -eE -o functrace
failure(){
    local lineno=$1
    local msg=$2
    echo "failed at $lineno : $msg"
}
trap 'failure $(LINENO) : "$BASH_COMMAND"' ERR

usage(){
    echo "usage : $0 <Please enter mail_id and app_passwd>"
}

if [ -z $mail_id&$app_passwd ]
then
usage
exit 1
fi 

User=$(id -u)
mail_id=$1
app_passwd=$2
file=/etc/postfix/main.cf

if [ $User -ne 0 ]
then
echo "Please run the script with root access"
exit 1
fi

echo "Updating yum repo"
yum update -y --exclude=kernel*


echo "Installing postfix, mailx, sasl"
yum install -y postfix cyrus-sasl-plain mailx


echo "Restarting postfix"
systemctl restart postfix


echo "Enabling postfix"
systemctl enable postfix

sed -i 's/smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt/#smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt'
sed -i 'i $ relayhost=[smtp.gmail.com]:587' -i 'a $ smtp_use_tls = yes' -i 'a $ smtp_sasl_auth_enable = yes' -i 'a $ smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd' -i 'a $ smtp_sasl_security_options = noanonymous' -i 'a $ smtp_sasl_tls_security_options = noanonymous' -i 'a $ smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt' "$file"

touch /etc/postfix/sasl_passwd

sed -i '1i [smtp.gmail.com]:587 $mail_id:$app_passwd'

echo "creating a lookup table for postfix"
postmap /etc/postfix/sasl_passwd

echo "sending mail"

echo "this is a test mail dated $(date)" | mail -s "Mail configuration success" jagadeeshjaga19@gmail.com
