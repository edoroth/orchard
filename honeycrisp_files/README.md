## Orchard

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

To re-run the code extraction process:
- clear the /root/cps-fuzz/extracted directory
- cd /root/cps-fuzz
- run 'stack run'

This will re-extract all benchmark algorithms into MAMBA MPC code which will be placed in the  /root/cps-fuzz/extracted directory.

Follow instructions in test/ec2.sh to run on an amazon EC2 instance - should be repeated on many machines to test full functionality.

