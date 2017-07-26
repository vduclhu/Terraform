resource "aws_vpc" "mod" {
  #provider = "${var.provider}"
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_internet_gateway" "mod" {
  #provider = "${var.provider}"
  vpc_id = "${aws_vpc.mod.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-igw", var.name)))}"
}

resource "aws_route_table" "public" {
  #provider = "${var.provider}"
  vpc_id           = "${aws_vpc.mod.id}"
  tags             = "${merge(var.tags, map("Name", format("%s-rt-public", var.name)))}"
}

resource "aws_route" "public_internet_gateway" {
  #provider = "${var.provider}"
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mod.id}"
}

resource "aws_subnet" "public" {
  #provider = "${var.provider}"
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${var.public_subnet}"
  availability_zone = "${var.azone}"
  tags              = "${merge(var.tags, var.public_subnet_tags, map("Name", format("%s-subnet-public-%s", var.name)))}"

  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
}

resource "aws_route_table_association" "public" {
  #provider = "${var.provider}"
  count          =  "1" #"${length(var.public_subnet)}"
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

