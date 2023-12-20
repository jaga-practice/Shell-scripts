#!/bin/bash
set -eE -o functrace
failure (){
    local lineno=$1
    local msg=$2
    echo "failed at $lineno:$msg"
}
trap 'failure $(LINENO):"$BASH_COMMAND"' ERR

 
File=home/centos/scripts/keyword

Unique=$(tr -s '[:space:]' '\n' < $File | sort | uniq -c)

echo "unique words are : $Unique"