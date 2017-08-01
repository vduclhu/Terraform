
module "vpc" {
  source = "./modules/vpc"
  name = "cosmos-devnet-edge1-tf"
  cidr = "10.200.0.0/16"
  public_subnet  = "10.200.0.0/24"
  public_subnet2  = "10.200.1.0/24"
  region = "sa-east-1"
  azone      = "sa-east-1a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-edge"
  }
}
module "vrouter1" {
  source = "./modules/vrouter"
  sgcount = "1"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-vrouter1-edge-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "sa-east-1"
  azone      = "sa-east-1a"
  CORE="yes"
  ami_csr="ami-43b6da2f"
  ami_region="ami-34afc458"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-edge"
  }
 
}


module "vpc2" {
  source = "./modules/vpc"
  name = "cosmos-devnet-edge2-tf"
  cidr = "10.201.0.0/16"
  public_subnet  = "10.201.0.0/24"
  public_subnet2  = "10.201.1.0/24"
  region = "sa-east-1"
  azone      = "sa-east-1a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-edge"
  }
}
module "vrouter2" {
  source = "./modules/vrouter"
  sgcount = "1"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-vrouter2-edge-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "sa-east-1"
  azone      = "sa-east-1a"
  CORE="yes"
  ami_csr="ami-43b6da2f"
  ami_region="ami-34afc458"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-edge"
  }
 
}
