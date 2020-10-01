# May need an update
# Run on EC2
#large
ssh -i "id_rsa_new.pem" ec2-user@ec2-3-15-193-164.us-east-2.compute.amazonaws.com # replace with your ec2 instance(s)

sudo yum update
sudo yum install git
sudo yum install docker

git clone https://github.com/edoroth/orchard.git
sudo service docker start
sudo docker build -t orchard .
sudo docker run -it orchard

cd SCALE-MAMBA

chmod 777 testd.sh

#edit for different query you would like to test
./testd.sh 9 histogram # Decryption: <total parties minus aggregator> <program name>




