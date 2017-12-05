#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for file in $(ls | grep -iE ".JPG|.PNG|.MP4|.MOV|.CR2|.M4V"); do
	if [ ! -f "${file}" ]; then
		echo "error '${file}'"
		continue
	fi
    #echo "${file}"
	filename=$(basename "${file}")
    # echo "[${file}] = [${filename}]"
	filename="${filename%.*}"

	extention=${file##*.}
	EXTENTION=$(echo $extention | tr '[:lower:]' '[:upper:]' )

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
        if [[ $REVERSE == 0 ]]; then
            match=${match:0:4}.${match:4:2}.${match:6:2}
        else
            match=${match:4:4}.${match:2:2}.${match:0:2}
        fi
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
	
    if [[ $match != '' ]]; then
        COMMENT="<from name>"
    else
        COMMENT="<from extra data>"
    fi

    if [ "$filename" != "$targetname" ]
    then
        echo "${file} -> ${targetname}.${EXTENTION} ${COMMENT}"
        mv "${file}" $targetname.$EXTENTION
    fi

    # FOLDERNAME=${targetname:0:10}    
    # 
    # if [ ! -d $FOLDERNAME ]; then
    #     echo "create [${FOLDERNAME}]"
    #     mkdir $FOLDERNAME
    # fi
    # 
    # mv $targetname.$EXTENTION $FOLDERNAME
done

IFS=$SAVEIFS
