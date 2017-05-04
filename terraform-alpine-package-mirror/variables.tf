variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}
variable "region" {

    default = "us-west-2"
}
variable "vpcid" {
    description = "enter your VPC id"
    default = "vpc-d3367db4"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-west-2 = "ami-a58d0dc5" # ubuntu 16.04 LTS
    }
}

variable "subnetid" {
    description = "enter subnet id"
    default = "subnet-d76203b0"
}
variable "azs" {

    default = {
        "us-west-2" = "us-west-2b"
    }
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







