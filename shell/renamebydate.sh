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

    REVERSE=0
    #YYYY/MM/DD
    match=$(echo "${filename}" | grep -oE "(20|19)[0-9]{2}[\/._-](0[1-9]|1[0-2])[\/._-](0[1-9]|[1-2][0-9]|3[0-1])" | sed 's/[^0-9]//g' )

    if [[ $match == '' ]]; then
        #YYYYMMDD
        match=$(echo "${filename}" | grep -oE "(20|19)[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])" | sed 's/[^0-9]//g' )
        REVERSE=0
    fi

    if [[ $match == '' ]]; then
        #DD/MM/YYYY
        match=$(echo "${filename}" | grep -oE "(0[1-9]|[1-2][0-9]|3[0-1])[\/._-](0[1-9]|1[0-2])[\/._-](20|19)[0-9]{2}" | sed 's/[^0-9]//g' )
        REVERSE=1
    fi

    if [[ $match == '' ]]; then
        #DDMMYYYY
        match=$(echo "${filename}" | grep -oE "(0[1-9]|[1-2][0-9]|3[0-1])(0[1-9]|1[0-2])(20|19)[0-9]{2}" | sed 's/[^0-9]//g' )
        REVERSE=1
    fi

	if [[ $match != '' ]]; then
		# echo ">>> ${match}"
        if [[ $REVERSE == 0 ]]; then
            match=${match:0:4}.${match:4:2}.${match:6:2}
        else
            match=${match:4:4}.${match:2:2}.${match:0:2}
        fi
		# echo ">>> ${match}"
		targetname=$(stat -f "%Sm" -t "(%H-%M)" "${file}")
		targetname="${match}_${targetname}"
	else
		# targetname=$(date -d @$(stat -f="%Y" "${file}") + "%Y.%m.%d_(%H-%M-%S)")
		targetname=$(stat -f "%Sm" -t "%Y.%m.%d_(%H-%M)" "${file}")
	fi

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

### deprecated
#i=0
#while [ -f "$newname.$EXTENTION" ]
#	do
#		i=$(( $i+1 ))
#		newname="$targetname-($i)"
#	done

    if [[ $match != '' ]]; then
        COMMENT="<from name>"
    else
        COMMENT="<from extra data>"
    fi

    echo "${file} -> ${newname}.${EXTENTION} ${COMMENT}"

	command="mv $file $newname.$EXTENTION"
	$command
done
