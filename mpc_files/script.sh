#!/bin/bash
set -x

./testd.sh 10 sparseVector 1000 >> results
./testd.sh 10 kmeans 1000 >> results
./testd.sh 10 countMeanSketch 1000 >> results
./testd.sh 10 perceptron 1000 >> results
./testd.sh 10 id3 1000 >> results
./testd.sh 20 sparseVector 1000 >> results
./testd.sh 20 kmeans 1000 >> results
./testd.sh 20 countMeanSketch 1000 >> results
./testd.sh 20 perceptron 1000 >> results
./testd.sh 20 id3 1000 >> results
./testd.sh 30 sparseVector 1000 >> results
./testd.sh 30 kmeans 1000 >> results
./testd.sh 30 countMeanSketch 1000 >> results
./testd.sh 30 perceptron 1000 >> results
./testd.sh 30 id3 1000 >> results

