#!/bin/bash
set -e
echo Compiling style sheets
npx xslt3 -xsl:./src/extractUids.xsl -export:./output/extractUids.sef.json -nogo 
npx xslt3 -xsl:./src/extractTags.xsl -export:./output/extractTags.sef.json -nogo 

for release in current 2020a 2020b 2020c 2020d 2020e 2019a 2019b 2019c 2019d 2019e 2018a 2018b 2018c 2018d 2018e 2017a 2017b 2017c 2017d 2017e 2016a 2016b 2016c 2016d 2016e 2015a 2015b 2015c 2014a 2014b 2014c
do
	for part in part06 part07
	do
		wget -P./input/$release -N http://dicom.nema.org/medical/dicom/$release/source/docbook/$part/$part.xml
	done

#	echo Generating UID registry
#	npx xslt3 -xsl:./output/extractUids.sef.json -s:./input/$release/part06.xml -o:./output/$release/uidRegistry.json
	
	echo Generating Tag registry
	npx xslt3 -xsl:./output/extractTags.sef.json -s:./input/$release/part06.xml -o:./output/$release/tagRegistry.json +part07=./input/$release/part07.xml

done


