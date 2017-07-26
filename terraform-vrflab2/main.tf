module "vpc" {
  source = "./modules/vpc"
  name = "cosmos-vrftest-tf"
  cidr = "10.101.0.0/16"
  public_subnet  = "10.101.0.0/24"
  region = "us-west-2"
  azone      = "us-west-2a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-test-vrfs"
  }
}
module "vrouter" {
  source = "./modules/vrouter"
  provider = "aws"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-vrftest-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "us-west-2"
  azone      = "us-west-2a"
  USERNAME="root"
  PASSWORD="WKq3d"
  NAME_SPACE="pog11"
  CORE="yes"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-test-vrfs"
  }
 
}
