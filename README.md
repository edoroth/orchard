## Orchard

This is a partial implementation of the Orchard private data analytics system. It does *not* include code to run a massively distributed data collection scheme on billions of devices. However, it does include the Orchard query engine which translates centralized queries into distributed ones. The resulting code is split into three parts: red, orange, and green zone code.
- The orange zone code can be executed inside of an MPC framework. We provide a prototype of this infrastructure, with the ability to simulate many committee devices on one machine. For ease of use and to prevent inordinate costs, we do not provide the EC2 infrastructure to run these queries in a fully distributed setting.
- The red zone code will be executed on user devices. We do not provide the infrastructure to run this code in a distributed way, but we provide benchmark numbers on the total costs associated with all user operations in Orchard.
- The green zone code will be executed on a centralized aggregator with access to massive resources, such as a data center. We provide benchmark numbers on the total costs associated with all agregator operations as well.

This repository also contains a simulation for malicious users attacking a facility clustering algorithm, and will produce the results that we report in the paper.

In summary, this repository contains:
- Orchard query translation source code (in cps_fuzz/)
- Raw .mpc files for all sample queries in the Orchard paper, translated into orange-zone code that can be run in SCALE-MAMBA, our MPC infrastructure (in mpc_files/)
- Orange-zone protocol testing infrastructure (in root-level folder)
- Numbers for the k-means robustness experiment to defend against malicious users (in robustness/)
- User and aggregation total cost numbers (in total_costs/)

## Instructions

All of our code is implemented within a docker to allow for easy set-up and cross-compatability performance.

## Docker Setup
Create a Docker image. This will take a few minutes (maybe up to half an hour). 
You only have to do this once (note: it may be necessary to allocate at least 8GB memory to Docker).
```
$ docker build -t orchard .
```
Spin up a Docker container from the image. 
```
$ docker run -it --rm orchard
```
Please note that any changes you make in the container are not persistent.

NOTE: if (for any reason), you are having any trouble with pip during the docker build, it may be because python2.7 is deprecated. If this occurs, please comment out the 4 'pip install' lines in the Dockerfile, and run the robustness/ experiment locally. These python libraries are only used for this portion of the experiments.

## Experiments

To re-run the code extraction process inside of the docker container, clear the /root/cps-fuzz/extracted directory, then:
```
$ cd /root/cps-fuzz
$ stack run
```

This will re-extract all benchmark algorithms into MAMBA MPC code which will be placed in the  /root/cps-fuzz/extracted directory (note: this code contains both red and orange-zone code. This is then split into the pure orange-zone code inside of /root/SCALE-MAMBA/Programs/).

For a walkthrough of how to write a *new* query, follow instructions in /root/cps-fuzz/ExampleQuery.md.

## Replication of Graphs/Tables in Paper

(assuming you are running inside of the docker created above.)

### Table 2
Examine the generated code in /root/cps-fuzz/extracted. The number of BMCS calls in each file should be the corresponding 'Optimized' column for each query's row. 

Since we only include one iteration in each query file, 'm' indicates that there will be one bmcs call in the extracted code, and 'm+1' indicates that there will be two bmcs calls, with only one of them required to be run in subsequent iterations.

 The 'Naive' column is manually generated, considering the total number of uploads towards a sum that each user must make for any given query.

### Figure 4
To generate data and produce the graph (will take around 6 minutes):
```
$ cd /root/robustness/
$ mkdir defenseFigures
$ python geogr.py >> geogrOut
``` 

This will populate a new .png image file in the defenseFigures/ folder. Note that to make this go faster, we run for less total trials (median across 10 trials, not 500!), so the data may be slightly different than reported in the paper. However, the numbers should be similar on expectation. You can play around with the parameters in geogr.py to use a different epsilon (set as 0.1) or different number of users (set as 4, meaning 10^4 total users) in the last line of this file.

'geogrOut' now also contains the raw data for Figure 4 (in the paper, we use this raw data and graph using gnuplot). 

### Figure 6
To simulate all committee members at once (without network costs):
```
$ cd /root/SCALE-MAMBA/
$ ./testd.sh $NUM_COMMITTEE_MEMBERS $PROG_NAME
```

Script must be run with at least 5 committee members (will take a few minutes to complete). One one machine, can be run with up to 15-17 committee members. The script will output Communication Cost in bytes, as well as timing. This script will not produce identical numbers to those in the paper, as this requires a full distributed run with a full committee, however, the numbers should reveal a similar pattern.

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

### Figures 5, 7, 8

Install gnuplot 5.2 patchlevel 6 (should be in the docker, but this version can be installed manually, if there are any issues).

Go into '/root/total_costs' and run ```./plot_all.sh``` - this will populate all PDF files inside of the figures/ folder, which should be identical to those produced in the paper.

The explanations for these figures are listed in the 'data_explanations' file in this folder, giving parameters/measurements and the formulas used to calculate total costs.
