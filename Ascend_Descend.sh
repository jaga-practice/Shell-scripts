#!/bin/bash

set -eE -o functrace
failure() {
local lineno=$1
local msg=$2
echo "failed at $lineno : $msg"
}
trap 'failure $(LINENO) : "$BASH_COMMAND"' ERR

if [ $# -ne 1 ]
then 
  echo "Usage : $0 <Input file>"
  exit 2
fi

file=$1

Asc=$(sort -f $1)
des=$(sort -rf $1)

echo "Ascending order : $Asc"
echo "Decsending order : $Des"