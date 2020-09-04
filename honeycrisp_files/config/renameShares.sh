N_2=$1
DIR=$2
SUBSET=$3

for (( i=0; i< ${N_2}; i++ ))
do
  j=$( sed $((${i} + 1))'q;d' ${SUBSET} )
  sed 's/'${j}'/'${i}'/' ${DIR}/Player${j}_shareout.txt > ${DIR}/Player${i}_sharein.txt
done

