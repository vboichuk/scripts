#!/bin/bash

# cd "$(dirname "$0")"

#######################################################

# Input parameters

# parameter1 - name of target plist & png
TARGET=$1

#######################################################

echo "Will scale images in '${TARGET}'"

cd $TARGET
if (($? > 0)); then
	echo "[EE]"
    exit 1
fi

# scale img1
find . -name '*.??g' | while IFS=$'\n' read -r FILE; do
  filename=$(basename $FILE | sed 's/@2x././g')
  #echo $FILE
  H=$(sips -g pixelHeight "$FILE" | grep 'pixelHeight' | cut -d: -f2)
  W=$(sips -g pixelWidth "$FILE" | grep 'pixelWidth' | cut -d: -f2)
  H50=$(($H / 2))
  W50=$(($W / 2))
  sips --resampleHeight "$H50" "$FILE" > /dev/null
done

echo "[OK] completed"

exit 0