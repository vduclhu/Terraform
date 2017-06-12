#!/bin/bash
export USERNAME=$1
export PASSWORD=$2
export STATE=$3
export NAMESPACE=$4
export CORE=$5

export servkey="$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)"

if [ $STATE = "deploy" ]; then
sudo echo $servkey > .servkey
export block1="$(nsot networks list -c 10.0.0.0/10 next_network -p 16 -n 1)"
sudo nsot networks add --site-id 1 --cidr $block1 --attributes owner=$servkey
export subnet1="$(nsot networks list -c $block1 next_network -p 24 -n 1)"
sudo nsot networks add --site-id 1 --cidr $subnet1 --attributes owner=$servkey
export subnet3="$(nsot networks list -c $block3 next_network -p 24 -n 1)"
sudo nsot networks add --site-id 1 --cidr $subnet3 --attributes owner=$servkey

export block2="$(nsot networks list -c 10.0.0.0/10 next_network -p 16 -n 1)"
sudo nsot networks add --site-id 1 --cidr $block2 --attributes owner=$servkey
export subnet2="$(nsot networks list -c $block2 next_network -p 24 -n 1)"
sudo sudo nsot networks add --site-id 1 --cidr $subnet2 --attributes owner=$servkey
export subnet4="$(nsot networks list -c $block4 next_network -p 24 -n 1)"
sudo nsot networks add --site-id 1 --cidr $subnet4 --attributes owner=$servkey

curl -Ss -XPUT https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network1 -d value=$subnet1
curl -Ss -XPUT https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network2 -d value=$block1
curl -Ss -XPUT https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network3 -d value=$subnet2
curl -Ss -XPUT https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network4 -d value=$block2

sudo cat << EOF >> variables.tf

variable "vpc_cidr_region1" {
    description = "CIDR for the whole VPC"
    default = "$block1"
}
variable "vpc_cidr_region2" {
    description = "CIDR for the whole VPC"
    default = "$block2"
}

variable "public_subnet_cidr_region1" {
    description = "Vrouter Eth0 Net"
    default = "$subnet1"
}
variable "public_subnet3_cidr_region1" {
    description = "Vrouter Eth1 Net"
    default = "$subnet3"
}
variable "public_subnet_cidr_region2" {
    description = "Vrouter Eth0 Net"
    default = "$subnet2"
}
variable "public_subne4_cidr_region2" {
    description = "Vrouter Eth1 Net"
    default = "$subnet4"
}
variable "servkey" {
    description = "UID for VPC networks"
    default = "$servkey"
}
EOF
sleep 2

sudo terraform apply -var USERNAME=$USERNAME -var PASSWORD=$PASSWORD -var NAME_SPACE=$NAMESPACE -var CORE=$CORE  -var-file terraform.tfvars

fi
if [ $STATE = "destroy" ]; then
echo $STATE
export servkey="$(terraform show | awk '/Servkey/ {print $3}')"
  net1=$(curl "https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network1" | cut -d '"' -f14)
  net2=$(curl "https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network2" | cut -d '"' -f14)
  net3=$(curl "https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network3" | cut -d '"' -f14)
  net4=$(curl "https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network4" | cut -d '"' -f14)

  sudo nsot networks remove --site-id 1 --cidr $net1 
  sudo nsot networks remove --site-id 1 --cidr $net2 
  sudo nsot networks remove --site-id 1 --cidr $net3
  sudo nsot networks remove --site-id 1 --cidr $net4
  
  sudo terraform destroy

else
echo "ENTER STATE VALUE!!"
fi
