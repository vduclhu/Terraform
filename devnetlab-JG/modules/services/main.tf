
resource "aws_security_group" "cosmos-vrouter_region" {
    #provider = "${var.provider}"
    name = "cosmos-devnet-services-sg"
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
        from_port = 8990
        to_port = 8990
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 2379
        to_port = 2379
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress {
        from_port = 2380
        to_port = 2380
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 4001
        to_port = 4001
        protocol = "tcp"
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
        Name = "cosmos-devnet-JG-LAB-SG"
        environment = "cosmos-test"
    }
}
resource "random_id" "sshkey" {
  byte_length = 8
}


resource "aws_key_pair" "cosmos-admin" {
  # provider = "${var.provider}"
  key_name = "cosmos ${random_id.sshkey.hex}"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

  resource "aws_instance" "cosmos-devnet-services" {
      #provider = "${var.provider}"
      ami = "${var.ami_services}"
      availability_zone = "${var.azone}"
      instance_type = "${var.vrouter_instance_type}"
      key_name = "${aws_key_pair.cosmos-admin.key_name}"
     vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter_region.id}"]
     subnet_id = "${var.public_subnet}"
      associate_public_ip_address = true
      source_dest_check = false
        provisioner "remote-exec" {
        inline = [
      "sudo apt update", 
      "sudo apt install docker.io",
      "sudo docker run -d -v /usr/share/ca-certificates/:/etc/ssl/certs -p 4001:4001 -p 2380:2380 -p 2379:2379 --name etcd quay.io/coreos/etcd:v2.3.8 -name etcd0 -advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 -initial-advertise-peer-urls http://${HostIP}:2380 -listen-peer-urls http://0.0.0.0:2380 -initial-cluster-token etcd-cluster-1 -initial-cluster etcd0=http://${HostIP}:2380 -initial-cluster-state new"
   ]
  }

      tags {
          Name = "cosmos-devnet-services-TF"
      }

    connection {
        user = "${var.INSTANCE_USERNAME}"
        private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
      }
    }

    resource "aws_route53_record" "www" {
  zone_id = "ZJUW1FLH7BIEB"
  name    = "sandboxjg"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.cosmos-devnet-services.public_ip}"]
}

