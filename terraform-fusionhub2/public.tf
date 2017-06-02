/*
  Vrouter
*/

#Create user for boto



resource "aws_security_group" "cosmos-vrouter_region1" {
    provider = "aws.canada"
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

resource "aws_instance" "cosmos-vrouter" {
    provider = "aws.canada"
    count = "${var.requirevrouter}"
    ami = "${var.ami_region1}"
    availability_zone = "ca-central-1b"
    instance_type = "t2.small"
    key_name = "cosmos-admin3"
    vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter_region1.id}"]
    subnet_id = "${aws_subnet.ca-central-1b-public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    iam_instance_profile = "cosmos_instance_profile"
    tags {
        Name = "cosmos-vrouter-TF"
    }

provisioner "file" {
    source      = "autoupdate.sh"
    destination = "/tmp/autoupdate.sh"
}
    provisioner "file" {
        source = "gcr-test.json"
        destination = "gcrtest.json"
    }
    provisioner "remote-exec" {
        inline = [
           "echo Y | sudo apt-get update",
           "echo Y | sudo apt-get install python",
           "echo Y | sudo apt-get install awscli",
           "echo Y | sudo apt-get install docker.io",
           "echo Y | sudo apt-get install jq",
           "chmod +x /tmp/autoupdate.sh",
           "echo sudo /tmp/autoupdate.sh ${var.USERNAME} ${var.PASSWORD} ${var.ETCD_HOST} ${aws_route_table_association.ca-central-1b-public.route_table_id} ${var.NAME_SPACE} | at now + 2 minute",
         "sudo aws ec2 authorize-security-group-ingress --group-id ${aws_security_group.cosmos-vrouter_region1.id} --protocol tcp --port 22 --cidr 203.0.113.0/24 --region us-west-2",
         "sudo docker login -e jeremiah.gearheart@pearson.com -u _json_key -p \"$(cat gcrtest.json)\" https://gcr.io",
         "sudo docker pull gcr.io/pearson-techops/cosmos/vrouter:COS-29",
         "sudo docker run --net host --privileged -e USERNAME=${var.USERNAME} -e PASSWORD=${var.PASSWORD} -e ETCD_DISCOVER=discover.blue-etcd.shared.prsn-dev.io -e NAMESPACE=${var.NAME_SPACE} -e CORE=${var.CORE} --name vrouter -itd gcr.io/pearson-techops/cosmos/vrouter:COS-29",
         "HOSTNAME=$(hostname | tr - _)"
         #"curl -X PUT https://root:${var.PASSWORD}@blue-etcd.shared.prsn-dev.io.:443/v2/keys/$HOSTNAME/routetableid -d value=\"${aws_route_table.ca-central-1b-public.id}\"",
         #"curl -X PUT https://root:${var.PASSWORD}@blue-etcd.shared.prsn-dev.io.:443/v2/keys/$HOSTNAME/cidrblock -d value=\"${aws_subnet.ca-central-1b-public.cidr_block}\"",
         #"curl -X PUT https://root:${var.PASSWORD}@blue-etcd.shared.prsn-dev.io.:443/v2/keys/$HOSTNAME/securitygroup -d value=\"${aws_security_group.cosmos-vrouter_region1.id}\"",
         #"curl -X PUT https://root:${var.PASSWORD}@blue-etcd.shared.prsn-dev.io.:443/v2/keys/$HOSTNAME/publicip -d value=\"${aws_instance.cosmos-vrouter.public_ip}\""

      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }

  }

  resource "aws_instance" "cosmos-testbox-region1" {
      provider = "aws.canada"
      ami = "${var.ami_region1}"
      availability_zone = "ca-central-1b"
      instance_type = "t2.small"
      key_name = "cosmos-admin3"
      vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter_region1.id}"]
      subnet_id = "${aws_subnet.ca-central-1b-public.id}"
      associate_public_ip_address = true
      source_dest_check = false


      tags {
          Name = "cosmos-testbox-TF"
      }

    connection {
        user = "${var.INSTANCE_USERNAME}"
        private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
      }
    }


resource "aws_route" "route" {
  provider = "aws.canada"
  route_table_id = "${aws_route_table_association.ca-central-1b-public.route_table_id}"
  destination_cidr_block = "10.0.0.0/8"
  instance_id = "${aws_instance.cosmos-vrouter.id}"
}




