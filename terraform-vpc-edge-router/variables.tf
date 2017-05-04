variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-1"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-west-1 = "ami-16efb076" # ubuntu 16.04 LTS
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.7.0.0/16"
}

variable "public_subnet_cidr" {
    description = "Vrouter Eth0 Net"
    default = "10.7.1.0/24"
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
  default = "0"
}







