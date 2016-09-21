#!/bin/bash
path=${1}
filename=$(basename "$path")
echo $filename
cp ${1} ~/Desktop/filename

perl -pe 's/\r\n|\n|\r/\n/g' $path > "${path}t1"
perl -pe 's/    /\t/g' "${path}t1" > "${path}ok"
mv "${path}ok" $path