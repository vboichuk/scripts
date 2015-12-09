#!/bin/bash
COUNT=git log --pretty=oneline origin master | wc -l
echo $COUNT