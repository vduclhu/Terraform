
module "vpc" {
  source = "./modules/vpc"
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

module "vpc2" {
  source = "./modules/vpc"
  name = "cosmos-devnet-tf"
  cidr = "10.112.0.0/16"
  public_subnet  = "10.112.0.0/24"
  region = "sa-east-1"
  azone      = "sa-east-1a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
}
module "vrouter2" {
  source = "./modules/vrouter"
  vpc_id =  "${module.vpc2.vpc_id}"
  ami_region = "ami-48bccb24"
  name = "cosmos-vrftest-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc2.public_subnet}"
  region = "sa-east-1"
  azone      = "sa-east-1a"
  USERNAME="root"
  PASSWORD="WKq3dU9Q"
  NAME_SPACE="pog11"
  CORE="no"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
 
}
