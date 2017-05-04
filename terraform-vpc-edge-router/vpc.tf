resource "aws_vpc" "cosmos-vrouter-testing" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "cosmos-vrouter-testing-aws-vpc-TF2"
    }
}

resource "aws_internet_gateway" "cosmos-vrouter-testing" {
    vpc_id = "${aws_vpc.cosmos-vrouter-testing.id}"
}



/*
  Public Subnet
*/
resource "aws_subnet" "us-west-1b-public" {
    vpc_id = "${aws_vpc.cosmos-vrouter-testing.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-west-1b"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-west-1b-public" {
    vpc_id = "${aws_vpc.cosmos-vrouter-testing.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cosmos-vrouter-testing.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-west-1b-public" {
    subnet_id = "${aws_subnet.us-west-1b-public.id}"
    route_table_id = "${aws_route_table.us-west-1b-public.id}"
}

