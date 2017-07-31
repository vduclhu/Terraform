
resource "random_id" "sshkey" {
  byte_length = 8
}

resource "aws_security_group" "cosmos-vrouter_region" {
    #provider = "${var.provider}"

    name = "cosmos-vrouter-sg ${random_id.sshkey.hex}"
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


    vpc_id = "${var.vpc_id}"

    tags {
        Name = "cosmos-vrouter-SG"
        environment = "cosmos-test"
    }
}


resource "aws_key_pair" "cosmos-admin" {
  #provider = "${var.provider}"
  key_name = "cosmos ${random_id.sshkey.hex}"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "cosmos-vrouter" {
    ##provider = "${var.provider}"
    count = "${var.vroutercount}"
    ami = "${var.ami_region}"
    availability_zone = "${var.azone}"
    instance_type = "${var.vrouter_instance_type}"
    key_name = "${aws_key_pair.cosmos-admin.key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter_region.id}"]
    subnet_id = "${var.public_subnet}"
    associate_public_ip_address = true
    source_dest_check = false
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
         #"sudo docker login -e jeremiah.gearheart@pearson.com -u _json_key -p \"$(cat gcrtest.json)\" https://gcr.io",
         #"sudo docker pull gcr.io/pearson-techops/cosmos/vrouter:COS-29",
         #"sudo docker run --net host --privileged -e USERNAME=${var.USERNAME} -e PASSWORD=${var.PASSWORD} -e ETCD_DISCOVER=discover.green-etcd.shared.prsn-dev.io -e NAMESPACE=${var.NAME_SPACE} -e CORE=${var.CORE} --name vrouter -itd gcr.io/pearson-techops/cosmos/vrouter:COS-29",
         "sudo docker run -itd --net host --privileged --name vrouter -e LAB_ETCD=http://sandbox.shared.prsn-dev.io:2379 sandbox.shared.prsn-dev.io:5000/vrouter:lab",
         "HOSTNAME=$(hostname | tr - _)"
        
      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }

  }
  resource "aws_instance" "cosmos-csr" {
    ami = "${var.ami_csr}"
    availability_zone = "${var.azone}"
    instance_type = "t2.medium"
    key_name = "${aws_key_pair.cosmos-admin.key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter_region.id}"]
    subnet_id = "${var.public_subnet}"
    associate_public_ip_address = true
    source_dest_check = false


      tags {
          Name = "cosmos-csr-TF"
      }
  }

