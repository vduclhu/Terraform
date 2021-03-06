#variable "aws_access_key" {}
#variable "aws_secret_key" {}
#variable "aws_key_path" {}
#variable "aws_key_name" {}

variable "provider" {
  description = "vpc id to be used"
  default     = ""
}
variable "sgcount" {
  description = "vpc id to be used"
  default     = "0"
}
variable "counter" {
  description = "added to name tag on instances"
  default     = "0"
}
variable "env" {
  description = "env tag"
  default     = ""
}


variable "vpc_id" {
  description = "vpc id to be used"
  default     = ""
}
variable "region" {
  description = "Name to be used on all the resources as identifier"
  default     = "us-west-2"
}
variable "vrouter_instance_type" {
    description = "instance size ex. t2.small"
    default = "t2.small"
}
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}
variable "public_subnet" {
  description = "subnet to be used"
  default     = ""
}

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
    default = "no"
}
variable "azone" {
    description = "AZ for vrouter region"
    default = "" # router AZ
}

variable "ami_region" {
    description = "AMIs by region"
    default = "ami-835b4efa" # ubuntu-oregon 16.04 LTS
}
variable "ami_csr" {
    description = "AMIs by region"
    default = "ami-835b4efa" # ubuntu-oregon 16.04 LTS
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
variable "vroutercount" {
  default = "1"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
