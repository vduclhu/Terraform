resource "aws_vpc" "cosmos-nsot-vpc" {
    provider = "aws.ohio"
    cidr_block = "${var.vpc_cidr_region1}"
    enable_dns_hostnames = true
    tags {
        Name = "cosmos-NSOT-TF"
    }
}

resource "aws_internet_gateway" "cosmos-nsot-vpc" {
    provider = "aws.ohio"
    vpc_id = "${aws_vpc.cosmos-nsot-vpc.id}"
}

resource "aws_subnet" "us-east-2a-public" {
    provider = "aws.ohio"
    vpc_id = "${aws_vpc.cosmos-nsot-vpc.id}"

    cidr_block = "${var.public_subnet_cidr_az1}"
    availability_zone = "us-east-2a"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_subnet" "us-east-2b-public" {
    provider = "aws.ohio"
    vpc_id = "${aws_vpc.cosmos-nsot-vpc.id}"

    cidr_block = "${var.public_subnet_cidr_az2}"
    availability_zone = "us-east-2b"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-east-2a-public" {
    provider = "aws.ohio"
    vpc_id = "${aws_vpc.cosmos-nsot-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cosmos-nsot-vpc.id}"
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
resource "aws_route_table_association" "us-east-2b-public" {
    provider = "aws.ohio"
    subnet_id = "${aws_subnet.us-east-2b-public.id}"
    route_table_id = "${aws_route_table.us-east-2a-public.id}"
}

