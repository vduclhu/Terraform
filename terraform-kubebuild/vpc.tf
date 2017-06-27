resource "aws_vpc" "kubelab_vpc" {   
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "kubelab_vpc"

    }
}

resource "aws_internet_gateway" "kubelab_vpc" {    
    vpc_id = "${aws_vpc.kubelab_vpc.id}"
}

resource "aws_subnet" "kubminion_subnet1" {
    vpc_id = "${aws_vpc.kubelab_vpc.id}"
    cidr_block = "${var.kubminion1_subnet}"
    availability_zone = "${var.azone1}"

    tags {
        Name = "kubelab_vpc_kubminion_subnet1"
    }
}
resource "aws_subnet" "kubminion_subnet2" {
    vpc_id = "${aws_vpc.kubelab_vpc.id}"
    cidr_block = "${var.kubminion2_subnet}"
    availability_zone = "${var.azone2}"

    tags {
        Name = "kubelab_vpc_kubminion_subnet2"
    }
}
resource "aws_subnet" "kubminion_subnet3" {
    vpc_id = "${aws_vpc.kubelab_vpc.id}"
    cidr_block = "${var.kubminion3_subnet}"
    availability_zone = "${var.azone3}"

    tags {
        Name = "kubelab_vpc_kubminion_subnet3"
    }
}
resource "aws_subnet" "kubminion_subnet4" {
    vpc_id = "${aws_vpc.kubelab_vpc.id}"
    cidr_block = "${var.kubminion4_subnet}"
    availability_zone = "${var.azone3}"

    tags {
        Name = "kubelab_vpc_kubminion_subnet4"
    }
}
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.kubelab_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.kubelab_vpc.id}"
    }
    tags {
        Name = "Public Subnet"
        environment = "kubelab_test"
    }
}

resource "aws_route_table_association" "public1" {
    subnet_id = "${aws_subnet.kubminion_subnet1.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "public2" {
    subnet_id = "${aws_subnet.kubminion_subnet2.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "public3" {
    subnet_id = "${aws_subnet.kubminion_subnet3.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "public4" {
    subnet_id = "${aws_subnet.kubminion_subnet4.id}"
    route_table_id = "${aws_route_table.public.id}"
}