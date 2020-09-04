# Run on EC2
#large
ssh -i "id_rsa_new.pem" ec2-user@ec2-3-15-193-164.us-east-2.compute.amazonaws.com # replace with your ec2 instance(s)


sudo yum update
sudo yum install git
sudo yum install docker

git clone https://github.com/danxinnoble/honeycrisp.git
cd honeycrisp
sudo service docker start
sudo docker build -t honeycrisp .
sudo docker run -it honeycrisp

cd SCALE-MAMBA

#edit for different number of parties you would like to test
sed -i "11s/.*/k = 20/" Programs/keygen/keygen.mpc
./test0.sh 21 21 1 # Keygen: <total parties> <participating parties> <threshold>

sed -i "8s/.*/k = 20/" Programs/decrypt/decrypt.mpc
./testd.sh 21 21 1 # Decryption: <total parties> <participating parties> <threshold>




