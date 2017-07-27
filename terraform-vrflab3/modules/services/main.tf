
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
resource "random_id" "sshkey" {
  byte_length = 8
}


resource "aws_key_pair" "cosmos-admin" {
  #provider = "${var.provider}"
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
  name    = "sandbox2"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.cosmos-devnet-services.public_ip}"]
}

