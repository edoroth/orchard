#echo 'REMINDER: did you edit the source code for new # of parties?'

N_1=$1
N_2=$1  # where N_2 <= N1 #eliminating for now, subset is a bit messed up

PROGRAM=$2

echo 'Modifying Program files accordingly...'

sed -i "10s/.*/k = $(($N_1-1)) \#Committee members (total participants is k+1)/" Programs/keygen/keygen.mpc
sed -i "1s/.*/k = $(($N_1-1)) \#Committee members (total participants is k+1)/" Programs/$PROGRAM/$PROGRAM.mpc

# Require THRESHOLD * 2 + 1 <= N2
THRESHOLD=2

#SIZE=$3
#sed -i "11s/.*/d = $SIZE \#Array size/" Programs/keygen/keygen.mpc
#sed -i "11s/.*/d = $SIZE \#Array size/" Programs/$PROGRAM/$PROGRAM.mpc


echo 'Running key-gen protocol...'
./test0.sh $N_1 $N_2 $THRESHOLD

#rm publicin.txt

echo 'Set up for protocol run...'

python chooseSubset.py ${N_1} ${N_2} > ./Data/subset.txt
echo 'Subset chosen:'
cat ./Data/subset.txt

./renameShares.sh ${N_2} ./Data ./Data/subset.txt > /dev/null

N_PLAYERS=$N_2

./genSetupOptions.sh ${N_2} ${THRESHOLD} | ./Setup.x > /dev/null

echo 'Compiling' $PROGRAM
reqs=$(./compile.py Programs/$PROGRAM | grep "Program requires:")

# For norm:
#perl -E 'print "1\n", "1\n", "1\n"' > ./Data/Player$(($N_PLAYERS - 1))\_in.txt

FILE="/Data/Player$(($N_PLAYERS - 1))\_in.txt"
if [ -f $FILE ]; then
   rm $FILE
fi

for i in `seq 500`
#for i in `seq 16386`
do 
  echo "1" >> ./Data/Player$(($N_PLAYERS - 1))\_in.txt
done

#getting rid of public input
#for i in `seq 8192`
#do 
#  echo "1" >> publicin.txt
#done'''

COMM_T0=$(cat /proc/net/dev | grep -o lo..\[0-9]\* | grep -o \[0-9\]*)

for (( i = 0; i <= $(($N_PLAYERS - 2)); i++ ))
do
  #cat publicin.txt | ./Player.x $i Programs/$4 &
  #./Player.x $i Programs/$PROGRAM > /dev/null 2> /dev/null &
  ./Player.x $i Programs/$PROGRAM & 
done

echo $Program 'costs for n='$N_1 ':'

time (./Player.x  $(($N_PLAYERS - 1)) Programs/$PROGRAM > /dev/null 2> /dev/null ) 
#time ( cat publicin.txt | ./Player.x  $(($N_PLAYERS - 1)) Programs/$4 > /dev/null 2> /dev/null ) 
#time (  ./Player.x  $(($N_PLAYERS - 1)) Programs/$PROGRAM > /dev/null 2> /dev/null ) 


COMM_T1=$(cat /proc/net/dev | grep -o lo..\[0-9]\* | grep -o \[0-9\]*)

if [[ $COMM_T0 != '' ]]
then
  echo 'Communication Cost (bytes):' $(($COMM_T1 - $COMM_T0))
else
  echo 'Communication Cost (bytes):' $COMM_T1
fi
