N_2=$1
SUBSET=$2
EVAL_POINTS=$3

for (( i=0; i< ${N_2}; i++ ))
do
  j=$( sed $((${i} + 1))'q;d' ${SUBSET} )
  xj=$( sed $((${j} + 1))'q;d' ${EVAL_POINTS} )
  echo ${xj}
done

