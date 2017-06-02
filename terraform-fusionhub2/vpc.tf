resource "aws_vpc" "cosmos-vrouter-corerouter-region1-vpc" {
    provider = "aws.canada"
    cidr_block = "${var.vpc_cidr_region1}"
    enable_dns_hostnames = true
    tags {
        Name = "cosmos-vrouter-corerouter-region1-vpc-FUSION-HUB-NONPROD-TF"
    }
}

resource "aws_internet_gateway" "cosmos-vrouter-corerouter-region1-vpc" {
    provider = "aws.canada"
    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region1-vpc.id}"
}

resource "aws_subnet" "ca-central-1b-public" {
    provider = "aws.canada"
    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region1-vpc.id}"

    cidr_block = "${var.public_subnet_cidr_region1}"
    availability_zone = "ca-central-1b"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "ca-central-1b-public" {
    provider = "aws.canada"
    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region1-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cosmos-vrouter-corerouter-region1-vpc.id}"
    }
    tags {
        Name = "Public Subnet"
        environment = "cosmos-test"
    }
}

resource "aws_route_table_association" "ca-central-1b-public" {
    provider = "aws.canada"
    subnet_id = "${aws_subnet.ca-central-1b-public.id}"
    route_table_id = "${aws_route_table.ca-central-1b-public.id}"
}

