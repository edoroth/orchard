N_1=$1
N_2=$2 
THRESHOLD=$3

python chooseSubset.py ${N_1} ${N_2} > ./Data/subset.txt
echo 'Subset chosen:'
cat ./Data/subset.txt

./renameShares.sh ${N_2} ./Data ./Data/subset.txt

./modifyEvalPoints.sh ${N_2} ./Data/subset.txt ./Data/evalPoints.txt > ./Data/evalPoints.txt.new
rm ./Data/evalPoints.txt
mv ./Data/evalPoints.txt.new ./Data/evalPoints.txt

./genSetupOptions.sh ${N_2} ${THRESHOLD} | ./Setup.x > /dev/null

echo 'Running part 2'