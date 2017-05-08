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
        us-west-1 = "ami-efd0428f" # ubuntu-oregon 16.04 LTS
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
    description = "Vrouter Eth0 Net"
    default = "10.10.1.0/24"
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

#-------------------------CANADA VARS--------------------------------------
variable "aws_region_canada" {
    description = "EC2 Region for the VPC"
    default = "ca-central-1"
}

variable "amis_canada" {
    description = "AMIs by region"
    default = {
        us-west-1 = "ami-b3d965d7" # ubuntu-canada 16.04 LTS
    }
}

variable "vpc_cidr_canada" {
    description = "CIDR for the whole VPC"
    default = "10.20.0.0/16"
}

variable "public_subnet_cidr_canada" {
    description = "Vrouter Eth0 Net"
    default = "10.20.1.0/24"
}
