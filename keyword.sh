#!/bin/bash
set -eE -o functrace
failure (){
    local lineno=$1
    local msg=$2
    echo "failed at $lineno:$msg"
}
trap 'failure $(LINENO):"$BASH_COMMAND"' ERR

if [ $# -ne 1 ]
then
echo "usage : $0 <Please enter the keyword>"
exit 1
fi 
 
File=home/centos/scripts/keyword
keyword=$1
while IFS= read -r line;
do
 echo($line | tr '[:upper:]' '[:lower:]' < $line | grep -q "$keyword")

  if [ $? -ne 0 ]
  then 
    echo "No matching keyword in $line"
    exit 1
    echo "Given "$keyword" is present in $line"
  fi
 done <<< "$File"
