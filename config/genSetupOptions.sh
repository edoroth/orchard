#!/bin/bash

N_PLAYERS=$1
THRESHOLD=$2  # Require 2*THRESHOLD < N_PLAYERS

echo 3
echo RootCA

echo $N_PLAYERS
for (( i = 0; i < $N_PLAYERS; i++ ))
do
  echo 127.0.0.1
  echo Player$i.crt
done

echo N
echo N
echo 2
echo 300424569129657234489620267994584186881

echo $THRESHOLD
