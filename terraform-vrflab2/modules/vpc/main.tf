resource "aws_vpc" "mod" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-igw", var.name)))}"
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.mod.id}"
  tags             = "${merge(var.tags, map("Name", format("%s-rt-public", var.name)))}"
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mod.id}"
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${var.public_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.public_subnets)}"
  tags              = "${merge(var.tags, var.public_subnet_tags, map("Name", format("%s-subnet-public-%s", var.name, element(var.azs, count.index))))}"

  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_security_group" "cosmos-vrouter" {
    name = "cosmos-vrouter-sg"
    description = "Allow incoming traffic"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["10.0.0.0/8"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["100.64.0.0/10"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 655
        to_port = 655
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 655
        to_port = 655
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress { # allow all outbound
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }


    vpc_id = "${aws_vpc.cosmos-vrouter-corerouter-region1-vpc.id}"

    tags {
        Name = "cosmos-vrouter-SG"
        environment = "cosmos-test"
    }
}
resource "aws_key_pair" "cosmos-admin" {
  provider = "aws.oregon"
  key_name = "cosmos-admin3"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "cosmos-vrouter" {
    provider = "aws.oregon"
    count = "${var.requirevrouter}"
    ami = "${var.ami_region1}"
    availability_zone = "us-west-2a"
    instance_type = "t2.small"
    key_name = "${aws_key_pair.cosmos-admin.key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter_region1.id}"]
    subnet_id = "${aws_subnet.us-west-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    iam_instance_profile = "${aws_iam_instance_profile.cosmos_instance_profile.name}"
    tags {
        Name = "cosmos-vrouter-TF"
    }

provisioner "file" {
    source      = "autoupdate.sh"
    destination = "/tmp/autoupdate.sh"
}
    provisioner "remote-exec" {
        inline = [
           "echo Y | sudo apt-get update",
           "echo Y | sudo apt-get install python",
           "echo Y | sudo apt-get install awscli",
           "echo Y | sudo apt-get install docker.io",
           "echo Y | sudo apt-get install jq",
           "sudo docker login registry.gitlab.com --username=jeremiah.gearheart@gmail.com --email=jeremiah.gearheart@gmail.com --password=${var.PASS2}",
           "chmod +x /tmp/autoupdate.sh",
         "sudo aws ec2 authorize-security-group-ingress --group-id ${aws_security_group.cosmos-vrouter_region1.id} --protocol tcp --port 22 --cidr 203.0.113.0/24 --region us-west-2",
         "sudo docker run -itd --restart always --privileged --device=/dev/net/tun --name vrouter -e TELEPORT_AUTH=true --net host -e ETCDCTL_PEERS=https://etcd.itc3.io:2379 -e VRF=global -e PORT=655 -e TELEPORT_PRIVATE=true -e CORE=true -e CLOUD=false registry.gitlab.com/itc3_artifacts/charts/vrouter_chart/itc3:vrouter",
         "HOSTNAME=$(hostname | tr - _)"
         #"curl -X PUT https://root:${var.PASSWORD}@blue-etcd.shared.prsn-dev.io.:443/v2/keys/$HOSTNAME/routetableid -d value=\"${aws_route_table.us-west-2a-public.id}\"",
         #"curl -X PUT https://root:${var.PASSWORD}@blue-etcd.shared.prsn-dev.io.:443/v2/keys/$HOSTNAME/cidrblock -d value=\"${aws_subnet.us-west-2a-public.cidr_block}\"",
         #"curl -X PUT https://root:${var.PASSWORD}@blue-etcd.shared.prsn-dev.io.:443/v2/keys/$HOSTNAME/securitygroup -d value=\"${aws_security_group.cosmos-vrouter_region1.id}\"",
         #"curl -X PUT https://root:${var.PASSWORD}@blue-etcd.shared.prsn-dev.io.:443/v2/keys/$HOSTNAME/publicip -d value=\"${aws_instance.cosmos-vrouter.public_ip}\""

      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }

  }