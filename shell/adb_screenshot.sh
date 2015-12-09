#!/bin/sh

#  auto_version.sh
#  
#
#  Created by v.boichuk on 1/20/14.
#
# Auto Increment Version Script
# set CFBundleVersion to 1.0.1 first!!!
# the perl regex splits out the last part of a build number (ie: 1.1.1) and increments it by one
# if you have a build number that is more than 3 components, add a '\.\d+' into the first part of the regex.

FILENAME=$1.png

if [[ $FILENAME == '' ]]; then
	FILENAME="screenshot.png"
fi

adb shell /system/bin/screencap -p /sdcard/$FILENAME
adb pull /sdcard/$FILENAME ~/Desktop/
open ~/Desktop/$FILENAME