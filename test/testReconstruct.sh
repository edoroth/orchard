#!/bin/bash

N_1=$1
N_2=$2  # where N_2 <= N1

# Require THRESHOLD * 2 + 1 <= N2
THRESHOLD=$3

#( make clean ; make progs ) > /dev/null

rm ./Data/*

seq ${N_1} > ./Data/evalPoints.txt

./genSetupOptions.sh ${N_1} ${THRESHOLD} | ./Setup.x > /dev/null


# the 2 is the number of output shares
echo 'Running part 1'
./benchmark.sh ./Programs/output_shares/ ${N_1} 2

python chooseSubset.py ${N_1} ${N_2} > ./Data/subset.txt
echo 'Subset chosen:'
cat ./Data/subset.txt

./renameShares.sh ${N_2} ./Data ./Data/subset.txt

./modifyEvalPoints.sh ${N_2} ./Data/subset.txt ./Data/evalPoints.txt > ./Data/evalPoints.txt.new
rm ./Data/evalPoints.txt
mv ./Data/evalPoints.txt.new ./Data/evalPoints.txt

./genSetupOptions.sh ${N_2} ${THRESHOLD} | ./Setup.x > /dev/null

echo 'Running part 2'
./benchmark.sh ./Programs/input_shares/ ${N_2} 3
echo 'Result:'
cat ./Data/Player0_out.txt
