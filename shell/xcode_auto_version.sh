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

buildPlistIPad=/Users/sergeytk/Documents/Albian/Project/proj.ios/Albian-ipad-Info.plist
buildPlistIPhone=/Users/sergeytk/Documents/Albian/Project/proj.ios/Albian-iphone-Info.plist

newVersionShort=`date +%d.%m.%y`
#newVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$buildPlist" | /usr/bin/perl -pe 's/(\d+\.\d+\.)(\d+)/$1.($2+1)/eg'`

echo "${newVersionShort}"

/usr/libexec/PListBuddy -c "Set :CFBundleShortVersionString $newVersionShort" "$buildPlistIPad"
/usr/libexec/PListBuddy -c "Set :CFBundleShortVersionString $newVersionShort" "$buildPlistIPhone"
# /usr/libexec/PListBuddy -c "Set :CFBundleVersion $newVersion" "$buildPlist"