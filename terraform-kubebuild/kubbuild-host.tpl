#!/bin/bash 

#Disable and stop the firewalld service 
 
sudo systemctl disable firewalld
sudo systemctl stop firewalld
 
#Download git, docker, and Apache web server
sudo yum install -y git docker httpd
 
#Configure docker to start on boot and start the service
sudo systemctl enable docker
sudo systemctl start docker
 
#Configure Apache to start on boot and start the service
sudo systemctl enable httpd
sudo systemctl start httpd

sudo git clone https://github.com/GoogleCloudPlatform/kubernetes.git

	
cd kubernetes/build
./run.sh hack/build-cross.sh

cd /root/kubernetes/_output/dockerized/bin/linux/amd64
cp * /var/www/html


cd /var/www/html
sudo git clone https://github.com/jonlangemak/kubernetes_build.git
