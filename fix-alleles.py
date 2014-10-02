#!/usr/bin/env python

import csv
import sys

if len( sys.argv ) < 4:
	print( 'USAGE: fix-alleles.py <good-alleles> <good-positions> <output>' )
	sys.exit( 1 )

if sys.argv[2] == sys.argv[3] or sys.argv[1] == sys.argv[3]:
	print( 'Input and output files are the same.' )
	sys.exit( 1 )

bim1 = open( sys.argv[1], 'r' )
bim2 = open( sys.argv[2], 'r' )
out  = csv.writer( open( sys.argv[3], 'w' ), delimiter = "\t", quoting = csv.QUOTE_NONE )

alleles = dict( (row[1], row[4:6]) for row in csv.reader( bim1, delimiter = "\t" ) )
for row in csv.reader( bim2, delimiter = "\t", quoting = csv.QUOTE_NONE ):
	out.writerow( row[0:4] + alleles[row[1]] )
