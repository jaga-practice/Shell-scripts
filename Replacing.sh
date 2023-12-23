#!/bin/bash

set -eE -o functrace
failure() {
local lineno=$1
lcal msg=$2
echo "failed at $lineno : $msg"
}
trap 'failure $(LINENO) : "$BASH_COMMAND"' ERR

if [ $# -ne 3 ]
then 
  echo "Usage : $0 <Input file>"
  exit 2
fi

file=$1
old_word=$2
new_word=$3

Replace=$(sed -e 's/$old_word/$new_word/g' $file) 
modified_file=$Replace
echo"modified_file : $modified_file"