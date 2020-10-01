#incr.sh
j=$1

sed -i "11s/.*/k = $j/" Programs/keygen/keygen.mpc
./test0.sh $((j+1)) $((j+1)) 1

sed -i "8s/.*/k = $j/" Programs/decrypt/decrypt.mpc
./testd.sh $((j+1)) $((j+1)) 1