module "vpc" {
  source = "./modules/vpc"

  name = "cosmos-vrftest-tf"

  cidr = "10.101.0.0/16"
  public_subnets  = ["10.101.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  azs      = ["us-west-2a", "us-west-2b", "us-west-2c"]

  tags {
    "Terraform" = "true"
    "Environment" = "${var.environment}"
  }
}
variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.101.0.0/16"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  default     = ["10.101.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "azs" {
  description = "A list of Availability zones in the region"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
