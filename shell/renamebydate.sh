#!/bin/bash

for file in $(find . -type f -iname '*.jpg' -maxdepth 1); do
	if [ ! -f "${file}" ]; then
		echo "erorr '${file}'"
		continue
	fi
    #echo "${file}"
	filename=$(basename "${file}")
    # echo "[${file}] = [${filename}]"
	filename="${filename%.*}"

	extention=${file##*.}
	EXTENTION=$(echo $extention | tr '[:lower:]' '[:upper:]' )
	# echo "${extention} => ${EXTENTION}"

	# try to find datetime in old file name
	match=$(echo "${filename}" | grep -oE "[1-2][0-9][0-9][0-9][._-]?[0-1][0-9][._-]*[0-3][0-9]" | sed 's/[^0-9]//g' )
	if [[ $match != '' ]]; then
		# echo ">>> ${match}"
		match=${match:0:4}.${match:4:2}.${match:6:2}
		# echo ">>> ${match}"
		targetname=$(stat -f "%Sm" -t "(%H-%M)" "${file}")
		targetname="${match}_${targetname}"
	else
		# targetname=$(date -d @$(stat -f="%Y" "${file}") + "%Y.%m.%d_(%H-%M-%S)")
		targetname=$(stat -f "%Sm" -t "%Y.%m.%d_(%H-%M)" "${file}")
	fi

    #echo "[${file}] = [${filename}].[${extention}]..."
	#echo "${filename}"

	# Adding short hach to filename
	hach=$(md5 "${file}" | grep -oE "[0-9a-f]{32}")
    hach=${hach:0:6}
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
