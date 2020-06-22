
Chinese Terminology Extraction

Organized version of the Chinese Termolator, parts of which 
uses some of the implementation from:
English Termolator https://github.com/AdamMeyers/The_Termolator
Original Termolator https://github.com/ivanhe/termolator/ 
Noun Chunker Generator by Leizhen Shi https://github.com/frank190/NounChunkerGenerator
This is part of an ongoing effort to organize and build on the Chinese Termolator.


USAGE
To perform Chinese terminology extraction, run the following command:
bash run_all_in_one.sh True/False desired_output_name 

True/False : indicating whether to use the dictionary feature
desired_output_name : can be replaced by any desired output name for the experiment

STEPS
The Chinese terminology extraction involves the following steps:

Step 0 : Preparation work
Preparation work uses the following: 
[tagged orange]
termUtilitiesEng.py
remove_xml_chinese.py
And of course, test_sample, a folder containing foreground and background text files to be processed

Step 1 : Tagging using Brandeis tagger
Tagging uses the following:
[tagged yellow]
Brandeis-CASIA-LanguageProcesser

Step 2 : Noun Chunker Generator
Noun Chunker Generator uses the following:
noun_chunker_generator.py
chinese1.txt

Step 3 : Distributional ranking
Distributional component uses the following:
[tagged blue]
When running the distributional, in order to use distributional_component.py as implemented for the English System,
Please ensure that the following files from the English Termolator is also in the same folder
Document.py
Metric.py
NPParser.py
Filter.py
Section.py
Settings.py
TestData.py
Wordlist.py
settings.txt
patentstops.txt

Step 4 : Accessor Variety Filter
Accessor variety filter uses the following:
[tagged purple]
accessorvariety.py
And output from previous stages:
[not tagged]*
.allterms file
foreground_tchunk_list

Bash script to run all:
[tagged red]
And we use run_all_in_one.sh to run everything together.
Usage example: bash run_all_in_one.sh True desired_output_name 
Final output file: desired_output_name.AV_filtered_terms

* All files generated in the process and final output files are not tagged
[If accessing the code on a Mac system, the color tags should be seen.]
This README file is tagged Gray.

Updated: June 22, 2020 by Yuling Gu