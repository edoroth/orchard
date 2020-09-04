echo 'REMINDER: did you edit the protocol source code for new # of parties?'
echo  'Does this have the right number of inputs for the protocol?'
N_1=$1
N_2=$2  # where N_2 <= N1

# Require THRESHOLD * 2 + 1 <= N2
THRESHOLD=$3

PROGRAM=$4
./compile.py Programs/$PROGRAM

rm publicin.txt

python chooseSubset.py ${N_1} ${N_2} > ./Data/subset.txt
echo 'Subset chosen:'
cat ./Data/subset.txt

./renameShares.sh ${N_2} ./Data ./Data/subset.txt

N_PLAYERS=$N_2

./genSetupOptions.sh ${N_2} ${THRESHOLD} | ./Setup.x > /dev/null


# For norm:
#perl -E 'print "1\n", "1\n", "1\n"' > ./Data/Player$(($N_PLAYERS - 1))\_in.txt

# For perceptron:
rm /Data/Player$(($N_PLAYERS - 1))\_in.txt
for i in `seq 8194`
do 
  echo "1" >> ./Data/Player$(($N_PLAYERS - 1))\_in.txt
done


for i in `seq 8192`
do 
  echo "1" >> publicin.txt
done

for (( i = 0; i <= $(($N_PLAYERS - 2)); i++ ))
do
  cat publicin.txt | ./Player.x $i Programs/$4 &
done

time ( cat publicin.txt | ./Player.x  $(($N_PLAYERS - 1)) Programs/$4 > /dev/null 2> /dev/null ) 


COMM_T1=$(cat /proc/net/dev | grep -o lo..\[0-9]\* | grep -o \[0-9\]*)

if [[ $COMM_T0 != '' ]]
then
  echo 'Communication Cost (bytes):' $(($COMM_T1 - $COMM_T0))
else
  echo 'Communication Cost (bytes):' $COMM_T1
fi