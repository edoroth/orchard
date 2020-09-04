#!/bin/bash

PROG_NAME=$1
N_PLAYERS=$2
N_IO=$3

echo 'Compiling' $PROG_NAME
reqs=$(./compile.py $PROG_NAME | grep "Program requires:")

echo $reqs

N_TRIPLES=$(echo $reqs | grep -o \'triple\'\)..\[0-9\]* | grep -o \[0-9\]*)
N_BITS=$(echo $reqs | grep -o \'bit\'\)..\[0-9\]* | grep -o \[0-9\]*)
N_SQUARES=$(echo $reqs | grep -o \'square\'\)..\[0-9\]* | grep -o \[0-9\]*)

if [[ $N_TRIPLES == '' ]]
then
  N_TRIPLES=1  # 1 instead of 0 since 0 represents infinity
fi

if [[ $N_BITS == '' ]]
then
  N_BITS=1
fi

if [[ $N_SQUARES == '' ]]
then
  N_SQUARES=1
fi

echo 
echo 'Measuring the runtime and communication cost of' $PROG_NAME

COMM_T0=$(cat /proc/net/dev | grep -o lo..\[0-9\]* | grep -o \[0-9\]*)

for (( i = 0; i <= $(($N_PLAYERS - 2)); i++ ))
do
  ./Player.x -max ${N_TRIPLES},${N_SQUARES},${N_BITS} -maxI ${N_IO} $i $PROG_NAME > /dev/null 2> /dev/null &
done

time (./Player.x -max ${N_TRIPLES},${N_SQUARES},${N_BITS} -maxI ${N_IO} $(($N_PLAYERS - 1)) $PROG_NAME > /dev/null 2> /dev/null ) 

COMM_T1=$(cat /proc/net/dev | grep -o lo..\[0-9]\* | grep -o \[0-9\]*)
if [[ $COMM_T0 != '' ]]
then
  echo 'Communication Cost (bytes):' $(($COMM_T1 - $COMM_T0))
else
  echo 'Communication Cost (bytes):' $COMM_T1
fi