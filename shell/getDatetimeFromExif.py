#!/usr/bin/env python3
 
# usage: exiv2_demo.py <file>
 
import sys
import pyexiv2
 
file = sys.argv[1]
 
metadata = pyexiv2.ImageMetadata(file)
metadata.read()
 
# print all exif tags in file
# for m in metadata.exif_keys:
#     print(m + "=" + str(metadata[m]))
 
# print specific tag 
# aperture = float(metadata['Exif.Photo.FNumber'].value)
# print("Aperture: F{}".format(aperture))

if 'Exif.Photo.DateTimeOriginal' in metadata:
	dateTimeOriginal = metadata['Exif.Photo.DateTimeOriginal'].value
	print(dateTimeOriginal)
