/*
  Vrouter
*/

#Create user for boto





resource "aws_security_group" "cosmos-vrouter_region1" {
    name = "cosmos-sg"
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


    vpc_id = "${aws_vpc.cosmos-vpc.id}"

    tags {
        Name = "cosmos-vrouter-SG"
        environment = "cosmos-test"
    }
}
resource "aws_key_pair" "cosmos-admin" {
  key_name = "cosmos-admin3"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_network_interface" "vrouter" {
  subnet_id                   = "${aws_subnet.public2.id}"
  security_groups             = ["${aws_security_group.vrouter.id}"]
}

resource "aws_instance" "cosmos-vrouter" {
    count = "${var.requirevrouter}"
    ami = "${var.ami_region1}"
    availability_zone = "us-west-2a"
    instance_type = "t2.small"
    key_name = "${aws_key_pair.cosmos-admin.key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter_region1.id}"]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    tags {
        Name = "cosmos-test2int-TF"
    }

provisioner "file" {
    source      = "addint.sh"
    destination = "/tmp/addint.sh"
}
    provisioner "remote-exec" {
        inline = [
        "echo Y | sudo apt-get update",
           "chmod +x /tmp/addint.sh",
           "echo sudo /tmp/addint.sh aws_network_interface.vrouter.id"


      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }

  }



