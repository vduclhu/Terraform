resource "aws_vpc" "cosmos-vrouter-corerouter-region1-vpc" {
    provider = "aws.oregon"
    cidr_block = "${var.vpc_cidr_region1}"
    enable_dns_hostnames = true
    tags {
        Name = "cosmos-vrouter-corerouter-region1-vpc-FUSION-HUB-NONPROD-TF"
        Servkey = "${var.servkey}"
    }
}

resource "aws_internet_gateway" "cosmos-vrouter-corerouter-region1-vpc" {
    provider = "aws.oregon"
    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region1-vpc.id}"
}

resource "aws_subnet" "us-west-2a-public" {
    provider = "aws.oregon"
    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region1-vpc.id}"

    cidr_block = "${var.public_subnet_cidr_region1}"
    availability_zone = "us-west-2a"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-west-2a-public" {
    provider = "aws.oregon"
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

resource "aws_route_table_association" "us-west-2a-public" {
    provider = "aws.oregon"
    subnet_id = "${aws_subnet.us-west-2a-public.id}"
    route_table_id = "${aws_route_table.us-west-2a-public.id}"
}

#----------------------VPC2----------------------------------------

resource "aws_vpc" "cosmos-vrouter-corerouter-region2-vpc" {
    provider = "aws.ohio"
    cidr_block = "${var.vpc_cidr_region2}"
    enable_dns_hostnames = true
    tags {
        Name = "cosmos-vrouter-corerouter-region2-vpc-FUSION-HUB-NONPROD-TF"
    }
}

resource "aws_internet_gateway" "cosmos-vrouter-corerouter-region2-vpc" {
    provider = "aws.ohio"
    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region2-vpc.id}"
}

resource "aws_subnet" "us-east-2a-public" {
    provider = "aws.ohio"
    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region2-vpc.id}"

    cidr_block = "${var.public_subnet_cidr_region2}"
    availability_zone = "us-east-2a"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-east-2a-public" {
    provider = "aws.ohio"
    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region2-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cosmos-vrouter-corerouter-region2-vpc.id}"
    }
    tags {
        Name = "Public Subnet"
        environment = "cosmos-test"
    }
}

resource "aws_route_table_association" "us-east-2a-public" {
    provider = "aws.ohio"
    subnet_id = "${aws_subnet.us-east-2a-public.id}"
    route_table_id = "${aws_route_table.us-east-2a-public.id}"
}
