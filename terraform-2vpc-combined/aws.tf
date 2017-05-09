provider "aws" {
  alias = "oregon"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region1}"
}

provider "aws" {
  alias = "ohio"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region2}"
}
