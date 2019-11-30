#!/bin/bash


SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

SCRIPTDIR=$(dirname "$0")
echo "$SCRIPTDIR"

for file in $(ls | grep -iE ".JPG|.JPEG|.PNG|.PSD|.CR2"); do
	if [ ! -f "${file}" ]; then
		echo "error '${file}'"
		continue
	fi
    #echo "${file}"

	# ================
	filename=$(basename "${file}")
	filename="${filename%.*}"

	extention=${file##*.}
	EXTENTION=$(echo $extention | tr '[:lower:]' '[:upper:]' )
	# ================
	targetname=""
	COMMENT=""

    EXIFDATETIME=$(python3 $SCRIPTDIR/getDatetimeFromExif.py "${file}" | sed 's/[^0-9]//g' )
    # 20191231164859   

	if [[ $EXIFDATETIME != '' ]]; then
		# echo "Exif: ${EXIFDATETIME}"
		#YYYYMMDDHHMMSS
		EXIFDATE=${EXIFDATETIME:0:4}.${EXIFDATETIME:4:2}.${EXIFDATETIME:6:2}
        EXIFTIME=${EXIFDATETIME:8:2}-${EXIFDATETIME:10:2}
    	
    	targetname="${EXIFDATE}_(${EXIFTIME})"
    	COMMENT="<from extra data>"
	else
		# try to find datetime in old file name
	    REVERSE=0
	    #YYYY/MM/DD (с разделителем)
	    matchDate=$(echo "${filename}" | grep -oE "(20|19)[0-9]{2}[\/._-](0[1-9]|1[0-2])[\/._-](0[1-9]|[1-2][0-9]|3[0-1])" | sed 's/[^0-9]//g' )
		matchTime=$(echo "${filename}" | grep -oE "([0-1][0-9]|2[0-3])[\/._-][0-5][0-9]" | tail -n 1 | sed 's/[^0-9]//g' )

	    if [[ $matchDate == '' ]]; then
	        #YYYYMMDD
	        matchDate=$(echo "${filename}" | grep -oE "(20|19)[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])" | sed 's/[^0-9]//g' )
	        matchTime=$(echo "${filename}" | grep -oE "([0-1][0-9]|2[0-3])[0-5][0-9][0-5][0-9]" | tail -n 1 | sed 's/[^0-9]//g' )
	        REVERSE=0
	    fi

	    if [[ $matchDate == '' ]]; then
	        #DD/MM/YYYY
	        matchDate=$(echo "${filename}" | grep -oE "(0[1-9]|[1-2][0-9]|3[0-1])[\/._-](0[1-9]|1[0-2])[\/._-](20|19)[0-9]{2}" | sed 's/[^0-9]//g' )
	        REVERSE=1
	    fi

	    if [[ $matchDate == '' ]]; then
	        #DDMMYYYY
	        matchDate=$(echo "${filename}" | grep -oE "(0[1-9]|[1-2][0-9]|3[0-1])(0[1-9]|1[0-2])(20|19)[0-9]{2}" | sed 's/[^0-9]//g' )
	        REVERSE=1
	    fi
		# echo "matchTime=[${matchTime}]"

		if [[ $matchDate != '' ]]; then
	        if [[ $REVERSE == 0 ]]; then
	            matchDate=${matchDate:0:4}.${matchDate:4:2}.${matchDate:6:2}
	            if [[ $matchTime != '' ]]; then
	            	matchTime=${matchTime:0:2}-${matchTime:2:2}
	        	fi
	        else
	            matchDate=${matchDate:4:4}.${matchDate:2:2}.${matchDate:0:2}
	        fi
			targetname="${matchDate}_(${matchTime})"
			COMMENT="<from name>"
		fi
		

	fi # [[ $EXIFDATETIME == '' ]];
	# echo "[${targetname}]"
	if [[ $targetname == '' ]]; then
		echo "Skip ${filename}.${EXTENTION}"
		continue
	fi

	# Adding short hach to filename
	hach=$(md5sum "${file}" | grep -oE "[0-9a-f]{32}")
    hach=${hach:0:6}
	targetname="$targetname-$hach"
	
    if [ "$filename" != "$targetname" ]
    then
        echo "${file} -> ${targetname}.${EXTENTION} ${COMMENT}"
        mv "${file}" $targetname.$EXTENTION
        if [ -f "${file}.xmp" ]; then
			mv "${file}.xmp" "${targetname}.${EXTENTION}.xmp"
			echo "${file}.xmp -> ${targetname}.${EXTENTION}.xmp"
	fi
        
        # exit 0
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
