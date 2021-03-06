variable "aws_access_key" {}
variable "aws_secret_key" {}
#variable "aws_key_path" {}
#variable "aws_key_name" {}


variable "aws_region1" {
    description = "EC2 Region for the VPC"
    default = "us-east-2"
}


variable "ami_region1" {
    description = "AMIs by region"
    default = "ami-fcc19b99" # ubuntu-ohio 16.04 LTS
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
variable "instance_type" {
  default = "t2.small"
}
variable "az1" {
  default = "us-east-2a"
}
variable "az2" {
  default = "us-east-2b"
}
variable "vpc_cidr_region1" {
    description = "CIDR for the whole VPC"
    default = "10.4.0.0/16"
}

variable "public_subnet_cidr_az1" {
    description = "nsot-app-server Eth0 Net"
    default = "10.4.0.0/24"
}
variable "public_subnet_cidr_az2" {
    description = "nsot-app-server Eth0 Net"
    default = "10.4.1.0/24"
}
variable "RDS_NAME" {
    description = "Name Given to RDS Instance"
    default = ""
}
variable "RDS_USER" {
    description = "UserName Given to RDS Instance"
    default = ""
}
variable "RDS_PASS" {
    description = "Password Given to RDS Instance"
    default = ""
}
variable "RDS_HOST" {
    description = "DNS/Hostname Given to RDS Instance"
    default = ""
}
variable "RDS_PORT" {
    description = "Port Used to access RDS Instance"
    default = ""
}
variable "NSOT_EMAIL" {
    description = "This will be used as your NSOT Username"
    default = ""
}
variable "NSOT_PASS" {
    description = "This will be used as your NSOT Password"
    default = ""
}
variable "requirensot" {
  default = "2"
}
