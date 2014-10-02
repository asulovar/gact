#!/bin/bash

# Originally from: http://www.well.ox.ac.uk/~wrayner/strand/
# Last edit on 11/02/2014 by Arvis Sulovari

#Required parameters:
#1. The original bed stem (not including file extension suffix)
#2. The strand file to apply
#3. The new stem for output
#Result: A new bed file (etc) using the new stem

#Unpack the parameters into labelled variables
stem=$1
strand_file=$2
outstem=$3
echo Input stem is $stem
echo Strand file is $strand_file
echo Output stem is $outstem

#Cut the strand file into a series of Plink slices
# This needs to be fixed in case multiple copies of this script are running at once.
chr_file=$stem.$(basename $strand_file).chr
pos_file=$stem.$(basename $strand_file).pos
flip_file=$stem.$(basename $strand_file).flip
cat $strand_file | cut -f 1,2 > $chr_file
cat $strand_file | cut -f 1,3 > $pos_file
cat $strand_file | awk '{if ($5=="-") print $0}' | cut -f 1 > $flip_file

#Because Plink only allows you to update one attribute at a time, we need lots of temp
#Plink files
# Added $$ to this to support parallel running. -RCH
temp_prefix=TEMP_FILE_XX72262628_$$_
temp1=$temp_prefix"1"
temp2=$temp_prefix"2"
temp3=$temp_prefix"3"

#1. Apply the chr
./plink --noweb --allow-no-sex --file $stem --update-map $chr_file --update-chr --make-bed --out $temp1
if [ "$?" != "0" ]; then
	exit 1
fi

#2. Apply the pos
./plink --noweb --allow-no-sex --bfile $temp1 --update-map $pos_file --make-bed --out $temp2
if [ "$?" != "0" ]; then
	exit 1
fi

#Commenting out the line below because the flip here is incorrect -AS
#3. Apply the flip
#./plink --noweb --allow-no-sex --bfile $temp2 --flip $flip_file --make-bed --out $temp3
#Changed '-bfile $temp3' to '-bfile $temp2' to account for ommitting the flip
#4. Extract the SNPs in the pos file, we don't want SNPs that aren't in the strand file
./plink --noweb --allow-no-sex --bfile $temp2 --extract $pos_file --make-bed --out $outstem
if [ "$?" != "0" ]; then
	exit 1
fi

#Now delete any temporary artefacts produced
rm -f $temp_prefix*

