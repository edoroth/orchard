N_1=$1

PROGRAM=$2

# Require THRESHOLD * 2 + 1 <= N2
#THRESHOLD=$3
THRESHOLD=3
VERBOSE=$3

#( make clean ; make progs ) > /dev/null

rm ./Data/*

seq ${N_1} > ./Data/evalPoints.txt

./genSetupOptions.sh ${N_1} ${THRESHOLD} | ./Setup.x > /dev/null


# the 2 is the number of output shares
echo 'Running part 1'
./benchmark.sh ./Programs/$PROGRAM ${N_1} 2 $VERBOSE
