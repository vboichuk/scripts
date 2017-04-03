#!/bin/sh

# SAVEIFS=$IFS
# IFS=$(echo -en "\n\b")

THRESHOLD=0.15

DEBUG=0
if [ "$1" == "d" ]; then
	DEBUG=1
fi

if [ $DEBUG == 1 ]; then
	DUMMYPREF="+_+"
else
	DUMMYPREF="+_+"
fi

rm $DUMMYPREF*.JPG
echo "Preparing dummy images..."
# mid="50"
# range="25"
for infile in $(ls *.JPG); do
	
	# convert		-normalize  $infile "${DUMMYPREF}${infile}"

	AVG=$(convert $infile -colorspace Gray -resize 1x1\! -format "%[fx:int(100*r+.5)]" info:)

	convert	\
	-resize 64x64\! \
	\
	-threshold $AVG% \
	\
	$infile "${DUMMYPREF}${infile}"

	# -separate -fuzz $range% -fill black -combine \
	# -separate -fuzz $range% -fill black +opaque "gray($mid%)" -fill white +opaque black -combine \

	# convert 	 -separate -normalize -combine $infile "${DUMMYPREF}${infile}"
	# -colorspace Gray
done
echo "Preparing dummy images done"

OUTFOLDER="!result"

if [ $DEBUG == 0 ]; then
	if [ ! -d $OUTFOLDER ]; then
		mkdir $OUTFOLDER
	fi
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

GREPREG="\([0-9]+(\.[0-9]+)?([e][+-][0-9]+)?\)"


# DIFF="compare: image widths or heights differ 1968.03.23_(01.26)-92f3a3.JPG @ error/compare.c/CompareImageCommand/990."
# echo "DIFF=${DIFF}"
# DIFF=$(echo $DIFF | grep -oE $GREPREG | sed 's/[()]//g' )
# echo "DIFFSTR=${DIFF}"
# exit 0

metric="MSE"

# test=`compare -metric MSE stepa.png stepa_colornoise_2p5.png null`
# echo $test
# test=`compare -metric MSE stepa.png stepa_bc_20x0.png null`
# echo ""

# Function round(precision, number)
round() {
    n=$(printf "%.${1}g" "$2")
    if [ "$n" != "${n#*e}" ]
    then
        f="${n##*e-}"
        test "$n" = "$f" && f= || f=$[ $f+$1-1 ]
        printf "%0.${f}f" "$n"
    else
        printf "%s" "$n"
    fi
}

comp() {

	comfile1="${DUMMYPREF}${1}"
	comfile2="${DUMMYPREF}${2}"

    DIFF="$(compare -metric $metric $comfile1 $comfile2 null: 2>&1 )"

	DIFF=$(echo $DIFF | grep -oE $GREPREG | sed 's/[()]//g' )

	if [ "$DIFF" == "" ]; then
		echo "0"
	else
		DIFF=$(round 3 $DIFF)
		echo $DIFF
	fi
}


for infile1 in $(ls *.JPG); do

	if [[ $infile1 == $DUMMYPREF* ]]; then
		continue
	fi

	if [ ! -f $infile1 ]; then
		continue
	fi

	echo "${YELLOW}${infile1}${NC}"

	MATCHFOLDER="${OUTFOLDER}/${infile1}_/"
	
	for infile2 in $(ls *.JPG); do

		if [[ $infile2 == $DUMMYPREF* ]]; then
			continue
		fi

		if [[ ! $infile1 < $infile2 ]]; then
			continue
		fi

		DIFF=$(comp $infile1 $infile2)

		RES=$(echo "${DIFF} < $THRESHOLD" | bc)
		
		if [ $RES == "1" ]; then
			echo "${RED}${infile1} == ${infile2} (${DIFF})${NC}"
			if [ $DEBUG == 0 ]; then		
				if [ ! -d $MATCHFOLDER ]; then
					mkdir $MATCHFOLDER
				fi
				echo "${infile2} => ${MATCHFOLDER}"
				mv $infile2 $MATCHFOLDER
				cp "${DUMMYPREF}${infile2}" $MATCHFOLDER
			fi
		# else
			# echo "${infile1} <> ${infile2} (${DIFF})"
		fi
	done

	if [ $DEBUG == 0 ]; then
		if [ -d $MATCHFOLDER ]; then
			echo "${infile1} ==> ${MATCHFOLDER}"
			mv $infile1 $MATCHFOLDER
			cp "${DUMMYPREF}${infile1}" $MATCHFOLDER
		else
			mv $infile1 $OUTFOLDER

		fi
	fi
done

echo "Deleting dummy images..."
rm "${DUMMYPREF}*.JPG"
echo "Deleting dummy images done"

# IFS=$SAVEIFS