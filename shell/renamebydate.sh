#!/bin/bash

for file in $(find *.JPG -type f); do
    #echo "${file}"
	filename=$(basename "$file")
    #echo "[${file}] = [${filename}]..."
	filename="${filename%.*}"
	extention=${file##*.}
	EXTENTION=$(echo $extention | tr '[:lower:]' '[:upper:]' )
	# echo "${extention} => ${EXTENTION}"

    #echo "[${file}] = [${filename}].[${extention}]..."
	#echo "${filename}"

	hach=$(md5 $file | grep -oE "[0-9a-f]{32}")
    hach=${hach:0:6}

	# targetname=$(date -d @$(stat -f="%Y" "${file}") + "%Y.%m.%d_(%H-%M-%S)")
	targetname=$(stat -f "%Sm" -t "%Y.%m.%d_(%H-%M)" "${file}")
	targetname="$targetname-$hach"
	# echo $targetname

    if [ "$filename" = "$targetname" ]
	then
		continue
	fi
	
   	newname=$targetname

	i=0
	while [ -f "$newname.$EXTENTION" ]
	do	
		i=$(( $i+1 ))
		newname="$targetname-($i)"
	done

	echo "${file} -> ${newname}.${EXTENTION}"
	command="mv $file $newname.$EXTENTION"
	$command
done
