# -*- coding:utf-8 -*-

import xml.etree.ElementTree

# Setup
LANGUAGE_MODEL = "en"
LANGUAGE_TEST  = "fi"
TABLE_NAME = "tutorial"


# start
localization_path = "/Users/valentinaboichuk/Documents/Projects/Skoda/Resources/rsrc/strings/lang.{lang}/{table}.plist"

# read model
path = localization_path.replace("{lang}", LANGUAGE_MODEL)
path = path.replace("{table}", TABLE_NAME)

dc = xml.etree.ElementTree.parse(path).getroot().find('dict')

print("There are ", len(dc.findall('key')), " keys in " + LANGUAGE_MODEL)
map1 = { }
for child in dc.iter('key'):
	map1[child.text] = 1

# read test
path = localization_path.replace("{lang}", LANGUAGE_TEST)
path = path.replace("{table}", TABLE_NAME)

dc = xml.etree.ElementTree.parse(path).getroot().find('dict')

print("There are ", len(dc.findall('key')), " keys in " + LANGUAGE_TEST)
map2 = { }
for child in dc.iter('key'):
	map2[child.text] = 1

problems_count = 0
for key in map1.keys():
	if (map2.get(key) == None):
		print("[Missing key]:\n[" + key + "]\n\n")
		problems_count = problems_count + 1

print (problems_count, " problems")
