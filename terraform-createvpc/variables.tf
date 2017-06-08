variable "aws_access_key" {}
variable "aws_secret_key" {}
#variable "aws_key_path" {}
#variable "aws_key_name" {}

variable "USERNAME" {
    description = "etcduname/will be passed in at runtime"
    default = "test"
}

variable "PASSWORD" {
    description = "etcdpass/will be passed in at runtime"
    default = "test"
}
variable "ETCD_HOST" {
    description = "etcdhostname/will be passed in at runtime"
    default = "discover.blue-etcd.shared.prsn-dev.io"
}
variable "NAME_SPACE" {
    description="add a name for vrouter L2VPN"
    default = ""
}
variable "CORE" {
    description="pass value here if core router is desired"
    default = ""
}
variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}

variable "ami_region1" {
    description = "AMIs by region"
    default = "ami-b3d965d7" # ubuntu-oregon 16.04 LTS
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/cosmos-admin"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/cosmos-admin.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
variable "requirevrouter" {
  default = "1"
}


variable "vpc_cidr_region1" {
    description = "CIDR for the whole VPC"
    default = "10.10.0.0/16"
}
variable "public_subnet_cidr_region1" {
    description = "Vrouter Eth0 Net"
    default = "10.10.0.0/24"
}
