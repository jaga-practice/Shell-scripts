#!/bin/bash

set -eE -o functrace
failure() {
local lineno=$1
lcal msg=$2
echo "failed at $lineno : $msg"
}
trap 'failure $(LINENO) : "$BASH_COMMAND"' ERR

if [ $# -ne 1 ]
then
echo "usage : $0 <plesae input a file>"
exit 1
fi 

file=$1

largest=$(sed -e 's/ /\n/g' $1 | sort | uniq | awk '{print length, $0}' | sort -nr | head -n 1)
shortest=$(sed -e 's/ /\n/g' $1 | sort | uniq | awk '{print length, $0}' | sort -nr | tail -n 1)

echo "largest word : $largest"
echo "shortest word : $shortest"