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


    vpc_id = "${aws_vpc.cosmos-vrouter-edgerouter-oregon-vpc.id}"

    tags {
        Name = "cosmos-vrouter-SG"
    }
}
resource "aws_key_pair" "cosmos-admin" {
  key_name = "cosmos-admin3"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "cosmos-vrouter" {
    count = "${var.requirevrouter}"
    ami = "ami-efd0428f"
    availability_zone = "us-west-2a"
    instance_type = "t2.small"
    key_name = "${aws_key_pair.cosmos-admin.key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter.id}"]
    subnet_id = "${aws_subnet.us-west-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags {
        Name = "cosmos-vrouter"
    }

#provisioner "file" {
#      source = "script.sh"
#      destination = "/tmp/script.sh"
#  }
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
         "sudo docker pull gcr.io/pearson-techops/cosmos/vrouter:COS-204",
         "sudo docker run --net host --privileged -e USERNAME=root -e PASSWORD= -e ETCD_DISCOVER=discover.blue-etcd.shared.prsn-dev.io --name vrouter -itd gcr.io/pearson-techops/cosmos/vrouter:COS-204",
         "HOSTNAME=$(hostname | tr - _)",
         "curl -X PUT https://${USERNAME}:${PASSWORD}@blue-etcd.shared.prsn-dev.io/v2/keys/$HOSTNAME/sec_group -d value=\"${aws_security_group.cosmos-vrouter.id}\"",
         "curl -X PUT https://${USERNAME}:${PASSWORD}@blue-etcd.shared.prsn-dev.io/v2/keys/$HOSTNAME/cidrblock -d value=\"${aws_route_table.us-west-2a-public.id}\"",
         "curl -X PUT https://${USERNAME}:${PASSWORD}@blue-etcd.shared.prsn-dev.io/v2/keys/$HOSTNAME/cidrblock -d value=\"${aws_subnet.us-west-2a-public.cidr_block}\"",
         "curl -X PUT https://${USERNAME}:${PASSWORD}@blue-etcd.shared.prsn-dev.io/v2/keys/$HOSTNAME/vpcid -d value=\"${aws_vpc.cosmos-vrouter-edgerouter-oregon-vpc.cidr_block}}\"",
         "curl -X PUT https://${USERNAME}:${PASSWORD}@blue-etcd.shared.prsn-dev.io/v2/keys/$HOSTNAME/vpcid -d value=\"${aws_instance.cosmos-vrouter.public_ip}}\"",

      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }
  }

