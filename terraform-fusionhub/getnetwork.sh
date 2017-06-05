#!/bin/bash

export USERNAME=$1
export PASSWORD=$2
export STATE=$3

if [$STATE = "deploy"]; then
export servkey = "$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)"
echo $servkey > .servkey
export block1="$(nsot networks list -c 10.0.0.0/10 next_network -p 16 -n 1)"
nsot networks add --site-id 1 --cidr $block1 --attributes owner=$servkey
export subnet1="$(nsot networks list -c $block1 next_network -p 24 -n 1)"
nsot networks add --site-id 1 --cidr $subnet1 --attributes owner=$servkey

export block2="$(nsot networks list -c 10.0.0.0/10 next_network -p 16 -n 1)"
nsot networks add --site-id 1 --cidr $block2 --attributes owner=$servkey
export subnet2="$(nsot networks list -c $block2 next_network -p 24 -n 1)"
nsot networks add --site-id 1 --cidr $subnet2 --attributes owner=$servkey

curl -Ss -XPUT https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network1 -d value=$subnet1
curl -Ss -XPUT https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network2 -d value=$block1
curl -Ss -XPUT https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network3 -d value=$subnet2
curl -Ss -XPUT https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network4 -d value=$block2

cat << EOF >> variables.tf

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
variable "public_subnet_cidr_region2" {
    description = "Vrouter Eth0 Net"
    default = "$subnet2"
}
variable "servkey" {
    description = "UID for VPC networks"
    default = "$servkey"
}
EOF
sleep 2

terraform apply -var USERNAME=$USERNAME -var PASSWORD=$PASSWORD -var NAMESPACE=$NAMESPACE -var CORE=$CORE  -var-file terraform.tfvars

fi
if [$STATE = "destroy"]; then
export servkey = "$(terraform show | awk '/Servkey/ {print $3}')"
  net1=$(curl -Ss "https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network1" | jq -r '.network1')
  net2=$(curl -Ss "https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network2" | jq -r '.network2')
  net3=$(curl -Ss "https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network3" | jq -r '.network3')
  net4=$(curl -Ss "https://$USERNAME:$PASSWORD@blue-etcd.shared.prsn-dev.io.:443/v2/keys/tfbuild/$servkey/network4" | jq -r '.network4')

  nsot networks remove --site-id 1 --cidr $net1 
  nsot networks remove --site-id 1 --cidr $net2 
  nsot networks remove --site-id 1 --cidr $net3
  nsot networks remove --site-id 1 --cidr $net4

else
echo "ENTER STATE VALUE!!"