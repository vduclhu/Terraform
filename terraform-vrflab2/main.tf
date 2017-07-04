module "vpc" {
  source = "./modules/vpc"

  name = "cosmos-vrftest-tf"

  cidr = "10.101.0.0/16"
  public_subnets  = ["10.101.101.0/24", "10.101.102.0/24", "10.101.103.0/24"]

  azs      = ["us-west-2a", "us-west-2b", "us-west-2c"]

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-test-vrfs"
  }
}
module "vpc2" {
  source = "./modules/vpc"

  name = "cosmos-vrftest-tf"

  cidr = "10.102.0.0/16"
  public_subnets  = ["10.102.101.0/24", "10.102.102.0/24", "10.102.103.0/24"]

  azs      = ["us-west-2a", "us-west-2b", "us-west-2c"]

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-test-vrfs"
  }
}
