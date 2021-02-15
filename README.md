# dcmregistry2js
This project contains XSLT files to extract:
* the attribute data dictionaries from DICOM part 6 and part 7, and
* the UID registry from DICOM part 6
and to convert them to a JSON data dictionary format used by https://github.com/chafey/dicom2ion-js. (Alternatively an XML dictionary can be created.)

To use:
* Get a copy of the DICOM part 6 and part 7 XML files from http://www.dicomstandard.org/current
  * [Part 6](http://dicom.nema.org/medical/dicom/current/source/docbook/part06/) contains
    * Chapter 6. Registry of DICOM Data Elements
    * Chapter 7. Registry of DICOM File Meta Elements
    * Chapter 8. Registry of DICOM Directory Structuring Elements
    * Chapter 9. Registry of DICOM Dynamic RTP Payload Elements
    * Chapter A. Registry of DICOM Unique Identifiers
  * [Part 7](http://dicom.nema.org/medical/dicom/current/source/docbook/part07/) contains
    * Chapter E. Command Dictionary including E.1. Registry of DICOM Command Elements and E.2 Retired Command Fields
* Place the DICOM files part06.xml and part07.xml in the input directory.
* There are 4 xslt tasks configured in the project:
  * Generate ./dist/tagsRegistry.json
  * Generate ./dist/tagsRegistry.xml
  * Generate ./dist/uidRegistry.json
  * Generate ./dist/uidRegistry.xml
  Run the desired extraction task.
* Alternatively invoke the XSLT files (extractTags.xsl, extractUids.xsl) from your favourite tool or the commandline. 
  * extractTags.xl uses the part06.xml file as the source, and takes the following parameters:
    * format=json,xml - specify the desired output format (optional; default: json)
    * +part07={path/to/part07.xml} - specify the part07.xml file. (required; the "+" indicates this is an xml document-node)
  * extractUids.xl uses the part06.xml file as the source, and takes the following parameters:
    * format=json,xml - specify the desired output format (optional; default: json)

To Do:
* Improve the JSON output. The current output is a little ugly, but is compliant and funcitonal. The conversion is a combination of customized xslt and of some generic XML-to-JSON xslt. It may be possible to use the json namespace to craft something that will emit as nicer JSON.

To modify the xslt files, the VS Code extension [XSLT Interactive Debugger](https://marketplace.visualstudio.com/items?itemName=philschatz.vscode-xslt) may be useful.
