resource "aws_vpc" "cosmos-vpc" {   
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags {
        Name = "cosmos-vpc"

    }
}

resource "aws_internet_gateway" "cosmos-vpc" {    
    vpc_id = "${aws_vpc.cosmos-vpc.id}"
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.cosmos-vpc.id}"

    cidr_block = "10.0.0.0/24"
    availability_zone = "${var.az}"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.cosmos-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cosmos-vpc.id}"
    }
    tags {
        Name = "Public Subnet"
        environment = "cosmos-test"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

