#!/bin/bash
User=$(id -u)
file=/etc/postfix/main.cf

if [ $User -ne 0 ]
then
echo "Please run the script with root access"
exit 1
fi

validate (){
    if [$1 -ne 0 ]
    then 
    echo "$2... failed"
    exit 2
    else
    echo "$2... success"
    fi
}

echo "Updating yum repo"
yum update -y --exclude=kernel*
validate $? "yum repo update"

echo "Installing postfix, mailx, sasl"
yum install -y postfix cyrus-sasl-plain mailx
validate $? "Resources installation"

echo "Restarting postfix"
systemctl restart postfix
validate $? "postfix restart"

echo "Enabling postfix"
systemctl enable postfix
validate $? "Postfix enabling"

sed -i 'na relayhost = [smtp.gmail.com]:587' -i '(n+1)a smtp_use_tls = yes' -i '(n+2)a smtp_sasl_auth_enable = yes' -i '(n+3)a smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd' -i '(n+4)a smtp_sasl_security_options = noanonymous' -i '(n+5)a smtp_sasl_tls_security_options = noanonymous' -i '(n+6)a smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt' "$file"

touch /etc/postfix/sasl_passwd

sed -i '1i [smtp.gmail.com]:587 read mail id:read apppassword'

echo "creating a lookup table for postfix"
postmap /etc/postfix/sasl_passwd

echo "sending mail"

echo "this is a test mail dated $(date)" | mail -s "Mail configuration success" jagadeeshjaga19@gmail.com
validate $? "mail sent"