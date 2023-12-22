#!/bin/bash
set -eE -o functrace
failure() {
    local lineno=$1
    loacl msg=$2
    echo "failed at $lineno : $msg"
}
trap 'failure $(LINENO) " "$BASH_COMMAND"' ERR

File=$1

if [ ! -f  $File ]
then 
echo "File doesnot exist"
exit 1
fi 

if [ $# -ne 1 ]
then
echo "usage : $0 <Please input file>"
exit 12
fi

lines=$(wc -l < $File)
echo "No. of lines : $lines"

words=$(wc -w < $File)
echo "No.of words : $words"

characters=$(wc -m < $File)
echo "No.of characters : $characters"