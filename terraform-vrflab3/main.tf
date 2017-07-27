provider "aws" {
region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  provider = "aws.oregon"
  name = "cosmos-devnet-tf"
  cidr = "10.109.0.0/16"
  public_subnet  = "10.109.0.0/24"
  region = "us-west-2"
  azone      = "us-west-2a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
}
module "vrouter" {
  source = "./modules/vrouter"
  provider = "aws.oregon"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-vrftest-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "us-west-2"
  azone      = "us-west-2a"
  USERNAME="root"
  PASSWORD="WKq3dU9Q"
  NAME_SPACE="pog11"
  CORE="yes"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
 
}
module "services" {
  source = "./modules/services"
  provider = "aws.oregon"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-services"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "us-west-2"
  azone      = "us-west-2a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
 
}


