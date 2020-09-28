Implementation of Orchard
-------------------------

## Orchard

This is a partial implementation of the Orchard secure data analytics system. It does *not* include code to run a massively distributed data collection scheme on billions of devices. However, it does include the Orchard query engine which translates centralized queries into distributed ones. The resulting code is split into three parts: red, orange, and green zone code.
- The orange zone code can be executed inside of an MPC framework. We provide a prototype of this infrastructure, with the ability to simulate many committee devices on one machine. For ease of use and to prevent inordinate costs, we do not provide the EC2 infrastructure to run these queries in a fully distributed setting.
- The red zone code will be executed on user devices. We do not provide the infrastructure to run this code in a distributed way, but we provide estimates on the total costs associated with all user operations in Orchard.
- The green zone code will be executed on a centralized aggregator with access to massive resources, such as a data center. We provide estimates on the total costs associated with all agregator operations as well.

This repository also contains a simulation for malicious users attacking a facility clustering algorithm, and will produce the results that we report in the paper.

In summary, this repository contains:
- Complete orange-zone testing infrastructures (in root-level folder)
- Raw .mpc files for all sample queries in the Orchard paper, translated into orange-zone code that can be run in SCALE-MAMBA, our MPC infrastructure (in mpc_files/)
- Orchard query translation source code (in cps_fuzz/)
- Numbers for the k-means robustness experiment (in robustness/)
- User and aggregation total cost numbers (in total_costs/)



## Instructions

All of our code is implemented within a docker to allow for easy set-up and cross-compatability performance.

## Docker Setup
Create a Docker image. This will take a few minutes. You only have to do this
once (note: it may be necessary to allocate at least 8GB memory to Docker).
```
$ docker build -t orchard .
```
Spin up a Docker container from the image. 
```
$ docker run -it --rm orchard
```
Please note that any changes you make in the container are not persistent.

## Experiments

To re-run the code extraction process inside of the docker container, clear the /root/cps-fuzz/extracted directory, then:
```
$ cd /root/cps-fuzz
$ stack run
```

This will re-extract all benchmark algorithms into MAMBA MPC code which will be placed in the  /root/cps-fuzz/extracted directory (note: this code contains both red and orange-zone code. This is then split into the pure orange-zone code inside of /root/SCALE-MAMBA/Programs/).

To run on an amazon EC2 instance, first follow instructions in /root/test/ec2.sh to run orange-zone code - this should be repeated on many machines to test full functionality. This script creates a docker on its own for each instance.

## Replication of Graphs/Tables

(assuming you are running inside of the docker created above.)

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

