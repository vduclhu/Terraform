variable "region" {
  description = "Name to be used on all the resources as identifier"
  default     = "us-west-2"
}
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "public_subnet" {
  description = "A list of public subnets inside the VPC."
  default     = ""
}

variable "azone" {
  description = "A list of Availability zones in the region"
  default     = ""
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_nat_gateway" {
  description = "should be true if you want to provision NAT Gateways for each of your private networks"
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "should be false if you do not want to auto-assign public IP on launch"
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {}
}
variable "amis" {
  type = "map"
  default = {
    "us-west-1" = "ami-73f7da13"
    "us-west-2" = "ami-835b4efa"
    "us-east-1" = "ami-d15a75c7"
    "us-east-2" = "ami-8b92b4ee"
    "ca-central-1" = "ami-b3d965d7"
  }
}
/*
NOVA
us-east-1a
us-east-1b
us-east-1c
us-east-1d
us-east-1e
us-east-1f

Ohio
us-east-2a
us-east-2b
us-east-2c

Cali
us-west-1b
us-west-1c

Oregon
us-west-2a
us-west-2b
us-west-2c

Canada
ca-central-1a
ca-central-1b

London
eu-west-2a
eu-west-2b

*/