Implementation of Orchard
-------------------------

## Orchard

This repository contains:
- Complete Honeycrisp/Orchard testing infrastructures (in root-level folder)
- Raw .mpc files for running all queries on SCALE-MAMBA (in mpc_files/)
- Orchard translation source code (in cps_fuzz/)
- K-means robustness experiment (in robustness/)
- Early-stage notes on translation from Fuzz (in orchard_translation/)
- Entropy estimation files for optimization (not used in paper in the end)

This is a partial implementation of the Orchard secure data analytics system.

It is implemented within a docker to allow for easy set-up and cross-compatability performance.

## Docker Setup
Create a Docker image. This will take a few minutes. You only have to do this
once.
```
$ docker build -t orchard .
```
Spin up a Docker container from the image. 
```
$ docker run -it --rm orchard
```
Please note that any changes you make in the container are not persistent.

## Experiments

To re-run the code extraction process, clear the /root/cps-fuzz/extracted directory, then:
```
$ cd /root/cps-fuzz
$ stack run
```

This will re-extract all benchmark algorithms into MAMBA MPC code which will be placed in the  /root/cps-fuzz/extracted directory (note: this code contains both red and orange-zone code. This is then split into the pure orange-zone code inside of /root/SCALE-MAMBA/Programs/).

Follow instructions in /root/test/ec2.sh to run orange-zone code on an amazon EC2 instance - should be repeated on many machines to test full functionality.

## Replication of Graphs/Tables


### Table 2
Examine the generated code in /root/cps-fuzz/extracted. The number of BMCS calls in each file should be the corresponding 'Optimized' column for each query's row.

### Figure 4
To generate data:
```
$ cd /root/robustness/
$ python geogr.py >> geogrOut
``` 

'geogrOut' now has the raw data for Figure 4. Can be graphed with (may have to be done outside of Docker):
```
$ python geogr.py
```

### Figure 6
To simulate all committee members at once (without network costs):
```
$ cd /root/SCALE-MAMBA/
$ ./testd.sh $NUM_COMMITTEE_MEMBERS $PROG_NAME
```
Script will output Communication Cost in bytes, as well as timing.

Program names to test:
- bag_filter_sum_noise
- kmeans_iter
- logistic_iter
- naive_bayes
- pca
- perceptron_iter
- simple_expm
- above_threshold
- histogram
- vec_sum
- count_mean_sketch
- id3_iter
- cdf
- range_query
- kmedian_iter_medium

Follow instructions for EC2 SCALE-MAMBA experiment to simulate with real network costs. For each comittee member, create a large EC2 instance and run ./ec2.sh on the number of desired machines.

