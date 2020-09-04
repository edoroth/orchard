N_1=$1
N_2=$2  # where N_2 <= N1

# Require THRESHOLD * 2 + 1 <= N2
THRESHOLD=$3


python chooseSubset.py ${N_1} ${N_2} > ./Data/subset.txt
echo 'Subset chosen:'
cat ./Data/subset.txt

./renameShares.sh ${N_2} ./Data ./Data/subset.txt

N_PLAYERS=$N_2

./genSetupOptions.sh ${N_2} ${THRESHOLD} | ./Setup.x > /dev/null


perl -E 'print "1\n", "1\n", "1\n"' > Player$(($N_PLAYERS - 1))\_in.txt

for i in `seq 8192`
do 
  echo "1" >> publicin.txt
done

for (( i = 0; i <= $(($N_PLAYERS - 2)); i++ ))
do
  ./Player.x $i Programs/decrypt > /dev/null 2> /dev/null &
done

time ( cat publicin.txt | ./Player.x  $(($N_PLAYERS - 1)) Programs/decrypt > /dev/null 2> /dev/null ) 


COMM_T1=$(cat /proc/net/dev | grep -o lo..\[0-9]\* | grep -o \[0-9\]*)
echo 'Communication Cost (bytes):' $(($COMM_T1 - $COMM_T0))