/*
  Vrouter
*/
resource "aws_security_group" "cosmos-alpine-mirror" {
    name = "cosmos-alpine-mirror-sg"
    description = "Allow incoming traffic"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress { # allow all outbound
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }


  vpc_id = "${var.vpcid}"

    tags {
        Name = "cosmos-vrouter-SG"
    }
}
resource "aws_key_pair" "cosmos-admin" {
  key_name = "cosmos-admin2"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_efs_file_system" "cosmos-efs" {
    performance_mode = "generalPurpose"

    tags {
        Name = "cosmo-efs"
  }
}

resource "aws_efs_mount_target" "client-mount-target" {
    count = "${length(split(", ", lookup(var.azs, var.region)))}"
    file_system_id = "${aws_efs_file_system.cosmos-efs.id}"
    subnet_id = "${var.subnetid}"
}



resource "aws_instance" "cosmos-alpine-mirror" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "${element(split(", ", lookup(var.azs, var.region)), 0)}"
    instance_type = "t2.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-alpine-mirror.id}"]
    subnet_id = "${var.subnetid}"
    associate_public_ip_address = true
    source_dest_check = false


    tags {
        Name = "cosmos-alpine-mirror"
    }

  provisioner "remote-exec" {
      inline = [
         "echo Y | sudo apt-get update",
         "echo Y | sudo apt-get install nfs-common",
         "sudo mkdir efs",
         "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_mount_target.client-mount-target.dns_name}:/ efs",
         "echo Y | sudo apt-get install python",
         "echo Y | sudo apt-get install docker.io",
         "echo Y | sudo apt-get install docker-compose",
         "echo Y | sudo apt-get install make",
         "git clone https://github.com/jgearheart/alpine-package-mirror.git",
         "cd alpine-package-mirror/",
         "BUILD_ID=latest make build",
         "sudo docker-compose up -d",
      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }
  }

