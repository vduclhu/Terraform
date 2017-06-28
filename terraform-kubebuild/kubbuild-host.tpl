#!/bin/bash 

!Disable and stop the firewalld service 
sudo -s 
systemctl disable firewalld
systemctl stop firewalld
 
!Download git, docker, and Apache web server
yum install -y git docker httpd
 
!Configure docker to start on boot and start the service
systemctl enable docker
systemctl start docker
 
!Configure Apache to start on boot and start the service
systemctl enable httpd
systemctl start httpd

git clone https://github.com/GoogleCloudPlatform/kubernetes.git

	
cd kubernetes/build
./run.sh hack/build-cross.sh

cd /root/kubernetes/_output/dockerized/bin/linux/amd64
cp * /var/www/html


cd /var/www/html
git clone https://github.com/jonlangemak/kubernetes_build.git