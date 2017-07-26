module "vpc" {
  source = "./modules/vpc"
  provider = "aws.oregon"
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
    "Environment" = "cosmos-test-vrfs"
  }
 
}

module "vpc2" {
  source = "./modules/vpc"
  provider = "aws.cali"
  name = "cosmos-vrftest-tf"
  cidr = "10.102.0.0/16"
  public_subnet  = "10.102.0.0/24"
  region = "us-west-1"
  azone      = "us-west-1b"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-test-vrfs"
  }
}
module "vrouter2" {
  source = "./modules/vrouter"
  provider = "aws"
  vpc_id =  "${module.vpc2.vpc_id}"
  name = "cosmos-vrftest-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc2.public_subnet}"
  region = "us-west-1"
  azone      = "us-west-1b"
  USERNAME="root"
  PASSWORD="WKq3d"
  NAME_SPACE="pog11"
  CORE="yes"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-test-vrfs"
  }
 
}
