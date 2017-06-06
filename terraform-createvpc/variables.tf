variable "aws_access_key" {}
variable "aws_secret_key" {}


variable "aws_region" {
    default = "eu-west-1"
}

variable "aws_availability_zones" {
    default = {
    eu-west-1 = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    us-east-1 = ["eu-west-1b", "eu-west-1c", "eu-west-1d", "eu-west-1e"]
    }
}

