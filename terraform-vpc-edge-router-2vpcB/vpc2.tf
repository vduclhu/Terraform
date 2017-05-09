

resource "aws_vpc" "cosmos-vrouter-edgerouter-canada-vpc" {
    cidr_block = "${var.vpc_cidr_canada}"
    enable_dns_hostnames = true
    tags {
        Name = "cosmos-vrouter-edgerouter-canada-vpc-TF"
    }
}

resource "aws_internet_gateway" "cosmos-vrouter-edgerouter-canada-vpc" {
    vpc_id = "${aws_vpc.cosmos-vrouter-edgerouter-canada-vpc.id}"
}

resource "aws_subnet" "ca-central-1a-public" {
    vpc_id = "${aws_vpc.cosmos-vrouter-edgerouter-canada-vpc.id}"

    cidr_block = "${var.public_subnet_cidr_canada}"
    availability_zone = "ca-central-1a"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "ca-central-1a-public" {
    vpc_id = "${aws_vpc.cosmos-vrouter-edgerouter-canada-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cosmos-vrouter-edgerouter-canada-vpc.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "ca-central-1a-public" {
    subnet_id = "${aws_subnet.ca-central-1a-public.id}"
    route_table_id = "${aws_route_table.ca-central-1a-public.id}"
}

