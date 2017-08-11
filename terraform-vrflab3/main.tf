
module "vpc" {
  source = "./modules/vpc"
  name = "cosmos-devnet-tf"
  cidr = "10.109.0.0/16"
  public_subnet  = "10.109.0.0/24"
  public_subnet2  = "10.109.1.0/24"
  region = "sa-east-1"
  azone      = "sa-east-1a"
  azone2      = "sa-east-1c"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
}
module "vrouter1" {
  source = "./modules/vrouter"
  sgcount = "1"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-vrouter1-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "sa-east-1"
  azone      = "sa-east-1a"
  USERNAME="root"
  PASSWORD="WKq3dU9Q"
  NAME_SPACE="pog11"
  CORE="yes"
  ami_csr="ami-3036475c"
  ami_region="ami-34afc458"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
 
}
module "vrouter2" {
  source = "./modules/vrouter"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-vrouter2-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet2}"
  region = "sa-east-1"
  azone = "sa-east-1c"
  USERNAME="root"
  PASSWORD="WKq3dU9Q"
  NAME_SPACE="pog11"
  CORE="yes"
  ami_csr="ami-43b6da2f"
  ami_region="ami-34afc458"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
 
}
module "services" {
  source = "./modules/services"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-services"
  ami_services = "ami-9db8cff1"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "sa-east-1"
  azone      = "sa-east-1a"

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
  public_subnet2  = "10.112.1.0/24"
  region = "us-west-2"
  azone      = "us-west-2a"
  azone2 = "us-west-2b"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
}
module "vrouter3" {
  source = "./modules/vrouter"
  sgcount = "1"
  vpc_id =  "${module.vpc2.vpc_id}"
  ami_region = "ami-835b4efa"
  name = "cosmos-vrftest-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc2.public_subnet}"
  region = "us-west-2"
  azone      = "us-west-2a"
  USERNAME="root"
  PASSWORD="WKq3dU9Q"
  NAME_SPACE="pog11"
  CORE="yes"
  ami_csr="ami-119b0071"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
 
}
module "vrouter4" {
  source = "./modules/vrouter"
  vpc_id =  "${module.vpc2.vpc_id}"
  ami_region = "ami-835b4efa"
  name = "cosmos-vrftest-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc2.public_subnet2}"
  region = "us-west-2"
  azone      = "us-west-2b"
  USERNAME="root"
  PASSWORD="WKq3dU9Q"
  NAME_SPACE="pog11"
  CORE="yes"
  ami_csr="ami-119b0071"
  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
 
}
