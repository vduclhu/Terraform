module "vpc" {
  source = "./modules/vpc"

  name = "cosmos-vrftest-tf"
  provider = "oregon"

  cidr = "10.101.0.0/16"
  public_subnet  = "10.101.101.0/24"
  region = "us-west-2"
  azone      = "us-west-2a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-test-vrfs"
  }
}
module "vrouter" {
  source = "./modules/vrouter"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-vrftest-tf"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "us-west-2"
  azone      = "us-west-2a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-test-vrfs"
  }
 
}
