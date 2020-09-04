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

This will re-extract all benchmark algorithms into MAMBA MPC code which will be placed in the  /root/cps-fuzz/extracted directory.

Follow instructions in /root/test/ec2.sh to run on an amazon EC2 instance - should be repeated on many machines to test full functionality.

## Replication of Graphs/Tables


### Table 2
Examine the generated code in /root/cps-fuzz/extracted. The number of BMCS calls in each file should be the corresponding 'Optimized' column for each query's row.

### Figure 4
```
$ cd /root/robustness/
$ python kmeans.py
```
OR
```
$ python geogr.py >> geogrOut
$ python graph.py
``` 

### Figure 6
Follow docker instructions for EC2 SCALE-MAMBA experiment as described above

