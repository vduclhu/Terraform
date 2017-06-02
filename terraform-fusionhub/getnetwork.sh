#!/bin/bash

export block1="$(nsot networks list -c 10.0.0.0/10 next_network -p 16 -n 1)"
nsot networks add --site-id 1 --cidr $block1 --attributes owner=bitesize_dev
export subnet1="$(nsot networks list -c $block1 next_network -p 24 -n 1)"
nsot networks add --site-id 1 --cidr $subnet1 --attributes owner=bitesize_dev

export block2="$(nsot networks list -c 10.0.0.0/10 next_network -p 16 -n 1)"
nsot networks add --site-id 1 --cidr $block2 --attributes owner=bitesize_dev
export subnet2="$(nsot networks list -c $block2 next_network -p 24 -n 1)"
nsot networks add --site-id 1 --cidr $subnet2 --attributes owner=bitesize_dev

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
EOF



