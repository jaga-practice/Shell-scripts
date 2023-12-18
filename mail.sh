#!/bin/bash
TO=$1
SUBJECT=$2
BODY_CONTENT=$(sed -e 's/[]\/$*.^[]/\\&/g' <<< $3)
echo "escaped content : $BODY_CONTENT"
GROUP_NAME=$4
ALERT_TYPE=$2
template="/home/centos/templates/disk_usage_mail.html"

final_content=$(sed -e "s/TEAM/$GROUP_NAME/g" -e "s/BODY_CONTENT/$BODY_CONTENT/g" -e "s/ALERT_TYPE?$ALERT_TYPE/g" "$template")

echo "final_content : $final_content"

echo -e "$final_content" | mail -s $(echo -e "$SUBJECT\nContent-Type : text/html")" $TO




