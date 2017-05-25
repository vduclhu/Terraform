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
variable "aws_region1" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}
variable "aws_region2" {
    description = "EC2 Region for the VPC"
    default = "us-east-2"
}

variable "ami_region1" {
    description = "AMIs by region"
    default = "ami-efd0428f" # ubuntu-oregon 16.04 LTS
}

variable "ami_region2" {
    description = "AMIs by region"
    default = "ami-fcc19b99" # ubuntu-oregon 16.04 LTS
}

variable "vpc_cidr_region1" {
    description = "CIDR for the whole VPC"
    default = "10.10.0.0/16"
}
variable "vpc_cidr_region2" {
    description = "CIDR for the whole VPC"
    default = "10.15.0.0/16"
}

variable "public_subnet_cidr_region1" {
    description = "Vrouter Eth0 Net"
    default = "10.10.1.0/24"
}
variable "public_subnet_cidr_region2" {
    description = "Vrouter Eth0 Net"
    default = "10.15.1.0/24"
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
