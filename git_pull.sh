#!/bin/bash

YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "${YELLOW}Core:${NC}"

git pull origin master

#git submodule foreach git log -1 --pretty=%B

for ITEM in `git submodule`
do
if [ -d "$ITEM" ]; then
    cd "$ITEM"
    echo "${YELLOW}${ITEM}:${NC}"
    git pull origin master
    cd ..
fi
done


