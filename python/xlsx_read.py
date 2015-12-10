# -*- coding:utf-8 -*-

import xlrd
import xml.etree.cElementTree as ET
import os

# Setup

HEADER_ROW = 4

LANGUAGE_1 = "id"
LANGUAGE_2 = "sv_SE"
# LANGUAGE_2 = "fi_FI"
# LANGUAGE_2 = "pl_PL"

LOCALIZATION_IN = '/Users/valentinaboichuk/Documents/Projects/Skoda/localization/texts.xlsx'
LOCALIZATION_OUT = "/Users/valentinaboichuk/Documents/Projects/Skoda/Resources/rsrc/strings/lang.{lang}/{table}.plist"

# start
xl_workbook = xlrd.open_workbook(LOCALIZATION_IN, formatting_info = False)

sheet_names = xl_workbook.sheet_names()
# sheet_names = ["tutorial"]

def find_by_val_in_row(row, value):
	for col_index in xrange(len(row)):
		if (row[col_index] == value):
			return col_index
	return -1

def prepare(text):
	text = text.rstrip()
	text = text.replace(u"…", u"...")
	text = text.replace(u"{s}", u"%s")
	text = text.replace(u"{d}", u"%d")
	text = text.replace(u"{f}", u"%f")
	text = text.replace(u"{0f}", u"%.0f")
	return text

for sheetname in sheet_names:

	sheet = xl_workbook.sheet_by_name(sheetname)
	row = sheet.row_values(HEADER_ROW)
	
	ind_1 = find_by_val_in_row(row, LANGUAGE_1)
	ind_2 = find_by_val_in_row(row, LANGUAGE_2)
	
	if (ind_1 < 0) or (ind_2 < 0):
		print ("error processing ", sheetname)
		continue;

	#create an xml
	root = ET.Element("plist")
	doc = ET.SubElement(root, "dict")

	for rownum in range(sheet.nrows):
		row = sheet.row_values(rownum)
		value1 = row[ind_1]
		value2 = row[ind_2]

		value1 = prepare(value1)
		value2 = prepare(value2)

		if (not value1) or (not value2):
			continue
		ET.SubElement(doc, "key").text = value1
		ET.SubElement(doc, "string").text = value2

	tree = ET.ElementTree(root)
	lan = LANGUAGE_2.split("_", 1)[0]
	out_path = LOCALIZATION_OUT.replace("{lang}", lan)
	out_path = out_path.replace("{table}", sheetname)
	out_dir = os.path.dirname(out_path)
	if not os.path.exists(out_dir):
		os.makedirs(out_dir)
	print(( sheetname + " => " + out_path ))
	tree.write(out_path)
