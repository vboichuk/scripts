#!/bin/bash

YELLOW='\033[0;33m'
NC='\033[0m' # No Color

#echo "${YELLOW}Core:${NC}"

MESSAGE=$(git log -1 --pretty=%B)
echo "${MESSAGE}"

REVISION=$(grep -o "^[0-9]*" <<< $MESSAGE)
if [ ! "$REVISION" ]; then
	REVISION=$(git log -1 --pretty=format:"%h")
fi

echo "${REVISION}"

#echo "${YELLOW}Revision:${NC} $(grep -o "^[0-9]*" <<< $NUMBER)"