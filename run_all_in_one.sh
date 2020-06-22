# Author: Yuling Gu
# Date: Jun 21, 2020
# Description: Bash script with the current implementations of the 
# Chinese Termolator organized. 
# Usage format : bash run_all_in_one.sh $1 $2
# $1 = True or False (do we want to use the chinese dictionary?)
# $2 = desired_output_name
# Usage example: bash run_all_in_one.sh True desired_output_name

#!/usr/bin/env bash

# Using the xml files in "test_sample" folder (sampleBackground, sampleRDG) as test cases,
# steps for running the updated Chinese termolator from very scratch:


echo -e "Step 0 : Preparation work\nCleaning up foreground and foreground text input..."
# Note: Makes use of termUtilitiesEng.py

# Generate foreground and background filelists
ls -1 test_sample/sampleBackground/ | awk '{print "test_sample/sampleBackground/"$1}' > backgroundList.txt
ls -1 test_sample/sampleRDG/ | awk '{print "test_sample/sampleRDG/"$1}' > foregroundList.txt

# Remove xml tags and clean up the file of unwanted tags non-characters
python3 remove_xml_chinese.py backgroundList.txt cleaned
python3 remove_xml_chinese.py foregroundList.txt cleaned

# Create directories to organize cleaned xml files
DIR=test_cleaned
if [ -d "$DIR" ]; then
    rm -r $DIR
    echo "Old $DIR removed!"
fi
mkdir test_cleaned
mkdir test_cleaned/background/
mkdir test_cleaned/foreground/
mv test_sample/sampleBackground/*cleaned.xml test_cleaned/background/
mv test_sample/sampleRDG/*cleaned.xml test_cleaned/foreground/
ls -1 test_cleaned/background/ | awk '{print "test_cleaned/background/"$1}' > cleaned_backgroundList.txt
ls -1 test_cleaned/foreground/ | awk '{print "test_cleaned/foreground/"$1}' > cleaned_foregroundList.txt
echo



echo -e "Step 1 : Tagging using Brandeis tagger\nRunning Brandeis Chinese word segmenter and part-of-speech tagger..."
# create directories for POS tagged files
DIR=test_tagged
if [ -d "$DIR" ]; then
    rm -r $DIR
    echo "Old $DIR removed!"
fi
mkdir test_tagged
mkdir test_tagged/background/
mkdir test_tagged/foreground/

# Run Brandeis Chinese word segmenter and part-of-speech tagger
cd Brandeis-CASIA-LanguageProcesser
java -Xmx25000m -cp "./WS_POS_brandeis.jar" brandeis.transition.wordseg.WordSegmentToolkit -mode test -model model/train_brandeis.model.gz -test ../test_cleaned/background/ -out ../test_tagged/background
java -Xmx25000m -cp "./WS_POS_brandeis.jar" brandeis.transition.wordseg.WordSegmentToolkit -mode test -model model/train_brandeis.model.gz -test ../test_cleaned/foreground/ -out ../test_tagged/foreground
cd ..
echo



echo -e "Step 2 : Noun Chunker Generator\nGenerating .tchunk and .pos files for the distributional ranking..."
# noun_chunker_generator.py implemented by Leizhen
python3 noun_chunker_generator.py -f test_tagged/foreground -b test_tagged/background -d $1
echo



echo -e "Step 3 : Distributional ranking\nGenerating .tchunk and .pos files for the distributional ranking...\n"
# MEASURES = ['TFIDF', 'DRDC', 'KLDiv', 'Weighted'] , same as English version
ls -1 output_foreground/ | grep "tchunk$" | awk '{print "output_foreground/"$1}' > $2.internal_foreground_tchunk_list
ls -1 output_background/ | grep "tchunk$" | awk '{print "output_background/"$1}' > $2.internal_background_tchunk_list
./distributional_component.py NormalRank $2.internal_foreground_tchunk_list $2.all_terms False $2.internal_background_tchunk_list



echo -e "Step 4 : Accessor Variety Filter\nFiltering all terms obtained previously...\n"
python3 accessorvariety.py $2.all_terms foreground_tchunk_list > $2.AV_filtered_terms
echo -e "All steps completed! Final output file: $2.AV_filtered_terms"

