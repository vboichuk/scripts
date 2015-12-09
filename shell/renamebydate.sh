#!/bin/bash

for file in $(find *.JPG -type f); do
#echo "[${file}]..."
	filename=$(basename "$file")
#echo "[${file}] = [${filename}]..."	
	filename="${filename%.*}"
	extention=${file##*.}

#echo "[${file}] = [${filename}].[${extention}]..."
	
	# targetname=$(date -d @$(stat -f="%Y" "${file}") + "%Y.%m.%d_(%H-%M-%S)")
	targetname=$(stat -f "%Sm" -t "%Y.%m.%d_(%H-%M-%S)" "${file}")
	# echo $targetname

    if [ "$filename" = "$targetname" ]
	then
		#echo "$file is OK"
		continue
	fi
	
	newname=$targetname

	i=0
	while [ -f "$newname.$extention" ]
	do	
		#echo "$newname exists"
		i=$(( $i+1 ))		
		newname="$targetname-($i)"
	done
	
	echo "${file} -> ${newname}.${extention}"
	command="mv $file $newname.$extention"
	$command
	
done
