/*
  Vrouter
*/
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


    vpc_id = "${aws_vpc.cosmos-vrouter-testing.id}"

    tags {
        Name = "cosmos-vrouter-SG"
    }
}
resource "aws_key_pair" "cosmos-admin" {
  key_name = "cosmos-admin2"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "cosmos-vrouter" {
    count = "${var.requirevrouter}"
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-west-1b"
    instance_type = "t2.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter.id}"]
    subnet_id = "${aws_subnet.us-west-1b-public.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags {
        Name = "cosmos-vrouter"
    }

provisioner "file" {
      source = "script.sh"
      destination = "/tmp/script.sh"
  }
  provisioner "file" {
      source = "gcr-test.json"
      destination = "gcrtest.json"
  }
  provisioner "remote-exec" {
      inline = [
         "echo Y | sudo apt-get update",
         "echo Y | sudo apt-get install python",
         "echo Y | sudo apt-get install docker.io",
         "echo ${aws_security_group.cosmos-vrouter.id} >> test",
         "sudo docker login -e jeremiah.gearheart@pearson.com -u _json_key -p \"$(cat gcrtest.json)\" https://gcr.io",
         "sudo docker pull gcr.io/pearson-techops/cosmos/vrouter:latest",
         "sudo docker run -itd --restart always --privileged --net host --name vrouter -e ETCDCTL_PEERS=http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379  gcr.io/pearson-techops/cosmos/vrouter:latest",
         "HOSTNAME=$(hostname | tr - _)",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/sec_group -d value=\"${aws_security_group.cosmos-vrouter.id}\"",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/cidrblock -d value=\"${aws_route_table.us-west-1b-public.id}\"",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/cidrblock -d value=\"${aws_subnet.us-west-1b-public.cidr_block}\"",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/vpcid -d value=\"${aws_vpc.cosmos-vrouter-testing.cidr_block}}\"",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/vpcid -d value=\"${aws_instance.cosmos-vrouter.public_ip}}\"",
      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }
  }

