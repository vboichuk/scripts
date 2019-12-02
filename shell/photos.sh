#!/bin/bash

JPG_PATH=$1
CR2_PATH=$2

cd $CR2_PATH

if [ ! -d $CR2_PATH/todelete ]; then
	mkdir $CR2_PATH/todelete
fi

for file in $(ls *.CR2); do
	if [ ! -f "${file}" ]; then
		continue
	fi
	
	filename=$(basename "${file}")
	filename="${filename%.*}"

	extention=${file##*.}
	EXTENTION=$(echo $extention | tr '[:lower:]' '[:upper:]' )

	# echo "${filename}    ${EXTENTION}"
	if [ ! -f "${JPG_PATH}"/"${filename}-small".JPG ]; then
		echo "${file} should be removed"
		mv "${filename}".* ./todelete
	fi
done

echo "done"