#!/bin/bash

# Written by Robert Howe. Edited by Arvis Sulovari (last edit: July 10, 2014)

# Echo commands as they are run.

# Print usage if necessary
if [ -z "$7" ]; then
	echo "USAGE: $0 <input> <output> <old-allele> <new-allele> <old-genome> <new-genome> <microarray>" 1>&2
	exit 1
fi

# Get the basename
input=$1
output=$2
old_allele=$3
new_allele=$4
old_genome=$5
new_genome=$6
microarray=$7

base="tmp/$(basename $input)"

microarray_path=references/$microarray

# Make sure we give the valid input type
if [[ "$old_allele" == "FWD" ]]; then
	intype=dbsnp
elif [[ "$old_allele" == "TOP" ]]; then
	intype=top
elif [[ "$old_allele" == "AB" ]]; then
	intype=ilmnab
else
	intype=top
fi


# Convert the input file to a MAP file, creating dummy pedigree and family
# files.
python ./make-ped.py $input $base

# The first argument is the name of the stem file (the user uploaded file)
# without the suffix. The second argument is the name of the strand file which
# is specific to the microarray that the user chooses.
# TODO: Add the rest of the Illumina .strand files to the server.
if [[ "$new_genome" == "b37" ]]; then
	strand=$microarray_path/$new_genome.strand
elif [[ "$new_genome" == "b36" ]]; then
	strand=$microarray_path/$new_genome.strand
fi

# 
bash ./update_build.sh $base $strand $base.newbuild
if [ "$?" != "0" ]; then
	exit 1
fi

# Fix alleles in the file.
./fix-alleles.py $input $base.newbuild.bim $base.allelefix.bim
cp $base.allelefix.bim $base.newbuild.bim

# After updating the build to b37, check to see what allele type conversion the
# user wants. Make sure it is different from the old type.
if [ "$old_allele" == "$new_allele" ]; then
	echo "The old allele and new allele are the same." 1>&2
	exit 1
fi

# If the old allele is PLUS, we convert it to TOP and then run the conversion using TOP.
if [ "$old_allele" == "PLUS" ]; then
	# Flip the input BIM file using PLINK
	# First we need to make a fliplist
	annotation=$microarray_path/annotation.txt
	awk '($4 == "TOP" && $6 == "+") || ($4 == "BOT" && $6 == "+")' $annotation > $base.fliplist

	# Use PLINK to flip the file
	./plink --noweb --allow-no-sex \
		--bfile $base.newbuild \
		--flip $base.fliplist \
		--make-bed \
		--out $base.topallele
	if [ "$?" != "0" ]; then
		exit 1
	fi
	
	# Archive all $base.newbuild files
	for file in $base.newbuild.*; do
		mv "$file" "$base.newbuild.plusarchive.${file##*.}"
	done

	# Copy all of the topallele files to $base.newbuild
	for file in $base.topallele.*; do
		mv "$file" "$base.newbuild.${file##*.}"
	done
fi

if [ "$new_allele" == "PLUS" -a "$old_allele" != "PLUS" ]; then
	# Convert the input file into the TOP allele using GenGen. Here, GenGen is being
	# told that the input type (intype) is ilmnab, but it may be different.
	#
	# GenGen accepts the following intype or outtype codes: ilmnab (for A/B), dbsnp
	# (for FWD), and TOP (for TOP). It does not support the PLUS definition. GenGen
	# requires a .snptable file.
	snptable=$microarray_path/snptable.txt
	intype=ilmnab
	outtype=top
	gengen/convert_bim_allele.pl ${base}.newbuild.bim $snptable \
		-intype $intype \
		-outtype $outtype \
		-outfile ${base}.newbuild.tempnewallele.bim
	if [ "$?" != "0" ]; then
		exit 1
	fi

	# Copy the BED and FAM files along -- apparently GenGen doesn't do this.
	cp $base.newbuild.bed $base.newbuild.tempnewallele.bed
	cp $base.newbuild.fam $base.newbuild.tempnewallele.fam

	# Make a flip_list that contains all the SNP rsIDs (third column of the
	# annotation file: humanomni1-quad_v1-0_h.annot) of only those SNPs with values
	# of [TOP, -] or (inclusively) [BOT, +] in the 4th and 6th column respectively.
	# It might be best to have the fliplists for all the microarray strand files
	# ready on the directory so we don't have to generate them each time.
	annotation=$microarray_path/annotation.txt
	awk '(($4 == "TOP" && $6 == "-") || ($4 == "BOT" && $6 == "+")) {print $3}' $annotation > $base.fliplist

	# Flip in the output file from step 2 only SNPs from the appropriate fliplist.
	# If PLINK fails here, then one trick to do is just rename the .ped and the .fam
	# files as $base.newbuild.tempnewallele.fam and $base.newbuild.tempnewallele.ped
	# The user will eventually only download $base.newbuild.plusallele.bim
	./plink --noweb --allow-no-sex \
		--bfile $base.newbuild.tempnewallele \
		--flip $base.fliplist \
		--make-bed \
		--out $base.newbuild.plusallele
	if [ "$?" != "0" ]; then
		exit 1
	fi

	# Move the output to the base
	mv $base.newbuild.plusallele.bim $output

elif [ "$new_allele" == "TOP" -a "$old_allele" != "PLUS" -a "$old_allele" != "TOP" ]; then
	snptable=$microarray_path/snptable.txt
	gengen/convert_bim_allele.pl \
		$base.newbuild.bim \
		$snptable \
		-intype $intype \
		-outtype top \
		-outfile $output
	if [ "$?" != "0" ]; then
		exit 1
	fi

elif [ "$new_allele" == "AB" -a "$old_allele" != "AB" ]; then
	snptable=$microarray_path/snptable.txt
	gengen/convert_bim_allele.pl \
		$base.newbuild.bim \
		$snptable \
		-intype $intype \
		-outtype ilmnab \
		-outfile $output
	if [ "$?" != "0" ]; then
		exit 1
	fi

elif [ "$new_allele" == "FWD" -a "$old_allele" != "FWD" ]; then
	snptable=$microarray_path/snptable.txt
	gengen/convert_bim_allele.pl \
		$base.newbuild.bim \
		$snptable \
		-intype $intype \
		-outtype dbsnp \
		-outfile $output
	if [ "$?" != "0" ]; then
		exit 1
	fi
else
	cp $base.newbuild.bim $output
fi

rm $base.*
rm $base

