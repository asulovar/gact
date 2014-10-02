#!/usr/bin/env ruby

#########################################################################
# Arvis Sulovari - April 4th Pedicts Allele type using a Feed-forward Backpropagation neural network
#########################################################################

require 'rubygems'
require 'ai4r'


net_1 = Ai4r::NeuralNetwork::Backpropagation.new([3,4,3,1]) 
net_2 = Ai4r::NeuralNetwork::Backpropagation.new([3,4,3,1]) 
net_3 = Ai4r::NeuralNetwork::Backpropagation.new([3,4,3,1])


input_array = Array.new(3)


#PART 1: Create the input array

#Save bim file name
if ARGV.length > 0
	rawfile = File.expand_path ARGV.first.chomp
	bimfile = rawfile + '.unix' else
	puts "No filename supplied!"
	exit 1 end

# Convert to UNIX line endings
%x(tr -d '\\15\\32' < #{rawfile} > #{bimfile})

# Total length of the bim file
bim_length = %x(wc -l #{bimfile}) 
bim_length = bim_length.chomp.to_i


if bim_length < 50
 puts "short"
 exit 1 end

#AB
ab_count = %x(awk '($5 == "A" && $6 == "B" || $5 == "B" && $6 == "A"){print}' #{bimfile} | wc -l).chomp.to_f 
ab_count = ab_count/bim_length*100


#AA
aa_count = %x(awk '($5 == "A" && $6 == "A"){print}' #{bimfile} | wc -l).chomp.to_f 
aa_count = aa_count/bim_length*100
#puts aa_count

#AC
ac_count = %x(awk '($5 == "A" && $6 == "C"){print}' #{bimfile} | wc -l).chomp.to_f 
ac_count = ac_count/bim_length*100
#puts ac_count

#AT
at_count = %x(awk '($5 == "A" && $6 == "T"){print}' #{bimfile} | wc -l).chomp.to_f 
at_count = at_count/bim_length*100
#puts at_count


#AG
ag_count = %x(awk '($5 == "A" && $6 == "G"){print}' #{bimfile} | wc -l).chomp.to_f 
ag_count = ag_count/bim_length*100
#puts ag_count

#CA
ca_count = %x(awk '($5 == "C" && $6 == "A"){print}' #{bimfile} | wc -l).chomp.to_f 
ca_count = ca_count/bim_length*100
#puts ca_count

#CC
cc_count = %x(awk '($5 == "C" && $6 == "C"){print}' #{bimfile} | wc -l).chomp.to_f 
cc_count = cc_count/bim_length*100
#puts cc_count


#CT
ct_count = %x(awk '($5 == "C" && $6 == "T"){print}' #{bimfile} | wc -l).chomp.to_f 
ct_count = ct_count/bim_length*100
#puts ct_count


#CG
cg_count = %x(awk '($5 == "C" && $6 == "G"){print}' #{bimfile} | wc -l).chomp.to_f 
cg_count = cg_count/bim_length*100
#puts cg_count


#TA
ta_count = %x(awk '($5 == "T" && $6 == "A"){print}' #{bimfile} | wc -l).chomp.to_f 
ta_count = ta_count/bim_length*100
#puts ta_count

#TC
tc_count = %x(awk '($5 == "T" && $6 == "C"){print}' #{bimfile} | wc -l).chomp.to_f 
tc_count = tc_count/bim_length*100
#puts tc_count


#TT
tt_count = %x(awk '($5 == "T" && $6 == "T"){print}' #{bimfile} | wc -l).chomp.to_f 
tt_count = tt_count/bim_length*100
#puts tt_count

#TG
tg_count = %x(awk '($5 == "T" && $6 == "G"){print}' #{bimfile} | wc -l).chomp.to_f 
tg_count = tg_count/bim_length*100
#puts tg_count

#GA
ga_count = %x(awk '($5 == "G" && $6 == "A"){print}' #{bimfile} | wc -l).chomp.to_f 
ga_count = ga_count/bim_length*100
#puts ga_count

#GC
gc_count = %x(awk '($5 == "G" && $6 == "C"){print}' #{bimfile} | wc -l).chomp.to_f 
gc_count = gc_count/bim_length*100
#puts gc_count


#GT
gt_count = %x(awk '($5 == "G" && $6 == "T"){print}' #{bimfile} | wc -l).chomp.to_f 
gt_count = gt_count/bim_length*100
#puts gt_count

#GG
gg_count = %x(awk '($5 == "G" && $6 == "G"){print}' #{bimfile} | wc -l).chomp.to_f 
gg_count = gg_count/bim_length*100
#puts gg_count




#input_array = 
#[aa_count,ac_count,at_count,ag_count,ca_count,cc_count,ct_count,cg_count,ta_count,tc_count,tt_count,tg_count,ga_count,gc_count,gt_count,gg_count]
input_array = [ct_count*10,tc_count*10,ga_count*10]

#puts input_array


#PART 2: Train Neuralnets and predict the allele type based on the input array from Part 1

#puts "about to start training net_1: PLUS"

1000.times do |i|
#PLUS: from 1000 Genomes
net_1.train([18.3*10,14*10,22.8*10],[1]) 
net_1.train([25.76*10,10.26*10,28.48*10],[1]) 
net_1.train([26.29*10,9.82*10,29.14*10],[1]) 
net_1.train([27.17*10,10.114*10,26.802*10],[1]) 
net_1.train([25.561*10,10.93*10,25.955*10],[1]) 
net_1.train([24.513*10,11.3395*10,25.0195*10],[1]) 
net_1.train([23.5594*10,12.3856*10,23.5452*10],[1]) 
net_1.train([22.30471429*10,13.058*10,22.39085714*10],[1]) 
net_1.train([21.3065*10,13.7291*10,21.3224*10],[1]) 
net_1.train([20.7602*10,13.9596*10,20.86015*10],[1])

#FWD: from dbSNP
net_1.train([36.4*10,0*10,0*10],[0]) 
net_1.train([35.45*10,0*10,0*10],[0]) 
net_1.train([35.24*10,0*10,0*10],[0]) 
net_1.train([34.65714286*10,0*10,0*10],[0]) 
net_1.train([34.46666667*10,0*10,0*10],[0]) 
net_1.train([34.31*10,0*10,0*10],[0]) 
net_1.train([34.085*10,0*10,0*10],[0]) 
net_1.train([34.352*10,0*10,0*10],[0]) 
net_1.train([34.279*10,0*10,0*10],[0]) 
net_1.train([34.26980348*10,0*10,0*10],[0])

#TOP: from our data
net_1.train([0*10,0*10,32.43*10],[0]) 
net_1.train([0*10,0*10,32.495*10],[0]) 
net_1.train([0*10,0*10,34.43*10],[0]) 
net_1.train([0*10,0*10,34.71125*10],[0]) 
net_1.train([0*10,0*10,35.598125*10],[0]) 
net_1.train([0*10,0*10,36.13875*10],[0]) 
net_1.train([0*10,0*10,35.694375*10],[0]) 
net_1.train([0*10,0*10,35.50311111*10],[0])



end

#puts "Training net_2: FWD"
1000.times do |i|

#PLUS: from 1000 Genomes
net_2.train([18.3*10,14*10,22.8*10],[0]) 
net_2.train([25.76*10,10.26*10,28.48*10],[0]) 
net_2.train([26.29*10,9.82*10,29.14*10],[0]) 
net_2.train([27.17*10,10.114*10,26.802*10],[0]) 
net_2.train([25.561*10,10.93*10,25.955*10],[0]) 
net_2.train([24.513*10,11.3395*10,25.0195*10],[0]) 
net_2.train([23.5594*10,12.3856*10,23.5452*10],[0]) 
net_2.train([22.30471429*10,13.058*10,22.39085714*10],[0]) 
net_2.train([21.3065*10,13.7291*10,21.3224*10],[0]) 
net_2.train([20.7602*10,13.9596*10,20.86015*10],[0])

#FWD: from dbSNP
net_2.train([36.4*10,0*10,0*10],[1]) 
net_2.train([35.45*10,0*10,0*10],[1]) 
net_2.train([35.24*10,0*10,0*10],[1]) 
net_2.train([34.65714286*10,0*10,0*10],[1]) 
net_2.train([34.46666667*10,0*10,0*10],[1]) 
net_2.train([34.31*10,0*10,0*10],[1]) 
net_2.train([34.085*10,0*10,0*10],[1]) 
net_2.train([34.352*10,0*10,0*10],[1]) 
net_2.train([34.279*10,0*10,0*10],[1]) 
net_2.train([34.26980348*10,0*10,0*10],[1])

#TOP: from our data
net_2.train([0*10,0*10,32.43*10],[0]) 
net_2.train([0*10,0*10,32.495*10],[0]) 
net_2.train([0*10,0*10,34.43*10],[0]) 
net_2.train([0*10,0*10,34.71125*10],[0]) 
net_2.train([0*10,0*10,35.598125*10],[0]) 
net_2.train([0*10,0*10,36.13875*10],[0]) 
net_2.train([0*10,0*10,35.694375*10],[0]) 
net_2.train([0*10,0*10,35.50311111*10],[0])




end


#puts "Training net_3: TOP"


1000.times do |i|

#PLUS: from 1000 Genomes
net_3.train([18.3*10,14*10,22.8*10],[0]) 
net_3.train([25.76*10,10.26*10,28.48*10],[0]) 
net_3.train([26.29*10,9.82*10,29.14*10],[0]) 
net_3.train([27.17*10,10.114*10,26.802*10],[0]) 
net_3.train([25.561*10,10.93*10,25.955*10],[0]) 
net_3.train([24.513*10,11.3395*10,25.0195*10],[0]) 
net_3.train([23.5594*10,12.3856*10,23.5452*10],[0]) 
net_3.train([22.30471429*10,13.058*10,22.39085714*10],[0]) 
net_3.train([21.3065*10,13.7291*10,21.3224*10],[0]) 
net_3.train([20.7602*10,13.9596*10,20.86015*10],[0])

#FWD: from dbSNP
net_3.train([36.4*10,0*10,0*10],[0]) 
net_3.train([35.45*10,0*10,0*10],[0]) 
net_3.train([35.24*10,0*10,0*10],[0]) 
net_3.train([34.65714286*10,0*10,0*10],[0]) 
net_3.train([34.46666667*10,0*10,0*10],[0]) 
net_3.train([34.31*10,0*10,0*10],[0]) 
net_3.train([34.085*10,0*10,0*10],[0]) 
net_3.train([34.352*10,0*10,0*10],[0]) 
net_3.train([34.279*10,0*10,0*10],[0]) 
net_3.train([34.26980348*10,0*10,0*10],[0])

#TOP: from our data
net_3.train([0*10,0*10,32.43*10],[1]) 
net_3.train([0*10,0*10,32.495*10],[1]) 
net_3.train([0*10,0*10,34.43*10],[1]) 
net_3.train([0*10,0*10,34.71125*10],[1]) 
net_3.train([0*10,0*10,35.598125*10],[1]) 
net_3.train([0*10,0*10,36.13875*10],[1]) 
net_3.train([0*10,0*10,35.694375*10],[1]) 
net_3.train([0*10,0*10,35.50311111*10],[1])





end

#puts "Predicting the type of the file (#{bimfile}):"
if ab_count > 90
	puts "ab" elsif net_1.eval(input_array)[0] > net_2.eval(input_array)[0] && net_1.eval(input_array)[0] > net_3.eval(input_array)[0]
	puts "plus" 
elsif net_2.eval(input_array)[0] > net_1.eval(input_array)[0] && net_2.eval(input_array)[0] > net_3.eval(input_array)[0]
	puts "fwd" 
elsif net_3.eval(input_array)[0] > net_1.eval(input_array)[0] && net_3.eval(input_array)[0] > net_2.eval(input_array)[0]
	puts "top" 
else
	puts "num" 
end


#puts "=> #{net_1.eval(input_array)[0]*100} % likely to PLUS" puts "=> #{net_2.eval(input_array)[0]*100} 
#% likely to be FWD" puts "=> #{net_3.eval(input_array)[0]*100} % likely to be TOP"
