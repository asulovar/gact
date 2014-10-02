#!/usr/bin/env python

import sys
import csv

bimfile = sys.argv[1]
stem    = sys.argv[2] # Output stem

bim = open( bimfile, 'r' )
map = open( stem + '.map', 'w' )
ped = open( stem + '.ped', 'w' ) 
fam = open( stem + '.fam', 'w' )

map_writer = csv.writer( map, delimiter = '\t', quoting = csv.QUOTE_NONE )
ped_writer = csv.writer( ped, delimiter = '\t', quoting = csv.QUOTE_NONE )
fam_writer = csv.writer( fam, delimiter = '\t', quoting = csv.QUOTE_NONE )
ped_row = [0] * 6
for row in csv.reader( bim, delimiter = '\t' ):
	map_writer.writerow( row[0:4] )
	ped_row += row[4:6]
ped_writer.writerow( ped_row )
fam_writer.writerow( [0] * 6 )
