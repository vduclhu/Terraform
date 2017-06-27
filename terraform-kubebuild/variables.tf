variable "aws_access_key" {}
variable "aws_secret_key" {}



variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us_east_1"
}

variable "ami" {
    description = "AMIs by region"
    default = "ami-92aa8284" # CoreOS-US-east
}


variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/cosmos_admin"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/cosmos_admin.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
variable "requirevrouter" {
  default = "1"
}


variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.100.0.0/16"
}

variable "kubminion1_subnet" {
    description = "kube minion1 subnet"
    default = "10.100.1.0/24"
}
variable "kubminion2_subnet" {
    description = "kube minion2 subnet"
    default = "10.100.2.0/24"
}
variable "kubminion3_subnet" {
    description = "kube minion3 subnet"
    default = "10.100.3.0/24"
}
variable "kubminion4_subnet" {
    description = "kube minion4 subnet"
    default = "10.100.4.0/24"
}

variable "az1" {
    description = "az"
    default = "us-east-1a"
}
variable "az2" {
    description = "az"
    default = "us-east-1b"
}
variable "az3" {
    description = "az"
    default = "us-east-1c"
}