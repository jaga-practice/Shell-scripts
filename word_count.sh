#!/bin/bash
#setting pipe method to display failure
set -eE -o functrace
failure (){
    local lineno=$1
    local msg=$2
    echo "failed at $lineno:$msg"
}
trap 'failure $(LINENO) : "$BASH_COMMAND"' ERR

#Checking whether all arguments are passed or not if not redirect to it.
if [ $# -ne 1 ]
then
 echo "usage ; $0 <Please enter the name of the word to be searched>"
 exit 1
fi

File=home/centos/scripts/wordcount

wordcount=$(grep -o -w "$1" "$File" | wc -l)

echo "The word $1 has repeated in the $File file for $wordcount times"