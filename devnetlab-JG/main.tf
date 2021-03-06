
module "vpc" {
  source = "./modules/vpc"
  name = "cosmos-devnet-Core1-JG-LAB"
  cidr = "10.30.0.0/16"
  public_subnet  = "10.30.0.0/24"
  public_subnet2  = "10.30.1.0/24"
  region = "eu-central-1"
  azone      = "eu-central-1a"
  azone2      = "eu-central-1b"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-JG-LAB"
  }
}
module "vrouter1" {
  source = "./modules/vrouter"
  counter = "1"
  sgcount = "1"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-vrouter1-tf"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "eu-central-1"
  azone  = "eu-central-1a"
  USERNAME="root"
  PASSWORD="test"
  NAME_SPACE="pog11"
  CORE="yes"
  ami_csr="ami-7b27f814"
  ami_region="ami-1e339e71"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-CorevRouter-JG-LAB"
  }
 
}
module "vrouter2" {
  source = "./modules/vrouter"
  counter = "2"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-JG-tf"
  env = "cosmos-devnet-JG-TF"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet2}"
  region = "eu-central-1"
  azone  = "eu-central-1b"
  USERNAME="root"
  PASSWORD="WKq3dU9Q"
  NAME_SPACE="pog11"
  CORE="yes"
  ami_csr="ami-7b27f814"
  ami_region="ami-1e339e71"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-CorevRouter-JG-LAB"
  }
 
}
module "services" {
  source = "./modules/services"
  vpc_id =  "${module.vpc.vpc_id}"
  name = "cosmos-devnet-services"
  ami_services = "ami-1e339e71" #"ami-dba20bb4"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc.public_subnet}"
  region = "eu-central-1"
  azone  = "eu-central-1a"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet"
  }
 
}

module "vpc2" {
  source = "./modules/vpc"
  name = "cosmos-devnet-Core2-JG-LAB"
  cidr = "10.35.0.0/16"
  public_subnet  = "10.35.0.0/24"
  public_subnet2  = "10.35.1.0/24"
  region = "eu-central-1"
  azone      = "eu-central-1a"
  azone2      = "eu-central-1b"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-JG-LAB"
  }
}
module "vrouter3" {
  source = "./modules/vrouter"
  counter = "3"
  sgcount = "1"
  vpc_id =  "${module.vpc2.vpc_id}"
  name = "cosmos-devnet-JG-tf"
  env = "cosmos-devnet-JG-TF"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc2.public_subnet}"
  region = "eu-central-1"
  azone  = "eu-central-1a"
  CORE="yes"
  ami_csr="ami-7b27f814"
  ami_region="ami-1e339e71"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-CorevRouter3-JG-LAB"
  }
 
}
module "vrouter4" {
  source = "./modules/vrouter"
  vpc_id =  "${module.vpc2.vpc_id}"
  counter = "4"
  name = "cosmos-devnet-JG-tf"
  env = "cosmos-devnet-JG-TF"
  vrouter_instance_type = "t2.small"
  public_subnet  = "${module.vpc2.public_subnet2}"
  region = "eu-central-1"
  azone  = "eu-central-1b"
  CORE="yes"
  ami_csr="ami-7b27f814"
  ami_region="ami-1e339e71"

  tags {
    "Terraform" = "true"
    "Environment" = "cosmos-devnet-CorevRouter4-JG-LAB"
  }
 
}