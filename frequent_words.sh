#!/bin/bash
set -eE -o functrace

failure() {
    local lineno=41
    local msg=$2
    echo "failed at $lineno : $msg"
    }
trap 'failure $(LINENO) : "$BASH_COMMAND"' ERR

#check if the given file exists or not

if [ ! -f $File ]
then
echo "File doesnot exist"
exit 1
fi 

File=$1

#checking whether user is giving input or not

if [ $# -ne 1 ]
then
echo "Usage : $0 <plese provide filename>"
exit 1
fi 

frequency=$(cat $File | tr -s '[:space:]' '\n' | tr '[:upper:]' '[:lower:]' | sort | uniq -c)
frequent_word=($frequency | awk '{if ($1 > max) {max = $1; word = $2}} END{print word}')
echo "frequent word : $frequent_word"
