#hi.sh
sudo yum update
sudo yum install git
sudo yum install docker

git clone https://github.com/danxinnoble/honeycrisp.git
cd honeycrisp
sudo service docker start
sudo docker build -t honeycrisp .
sudo docker run -it honeycrisp

cd SCALE-MAMBA

./incr.sh 14