/*
  Vrouter
*/

#Create user for boto



#Create IAM role/policy
resource "aws_iam_role" "cosmos_role" 
{
	provider ="aws.oregon"
        name = "cosmos_role"		    
	assume_role_policy = "${file("cosmos_iam_role.json")}"	
}

resource "aws_iam_instance_profile" "cosmos_instance_profile" 
{		   
    provider ="aws.oregon" 
	name = "cosmos_instance_profile"		    
	roles = ["cosmos_role"]		
}

#Create cosmos IAM policy

resource "aws_iam_role_policy" "cosmos_iam_role_policy" 
{		  
    provider ="aws.oregon"
	name = "cosmos_iam_role_policy"		  
	role = "${aws_iam_role.cosmos_role.id}"		  
	policy = "${file("cosmos_iam_role_policy.json")}"
}

resource "aws_security_group" "cosmos-NSOT_region1" {
    provider = "aws.oregon"
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
        from_port = 8990
        to_port = 8990
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

resource "aws_instance" "cosmos-NSOT" {
    provider = "aws.oregon"
    ami = "${var.ami_region1}"
    availability_zone = "us-west-2a"
    instance_type = "t2.small"
    key_name = "${aws_key_pair.cosmos-admin.key_name}"
    vpc_security_group_ids = ["${aws_security_group.cosmos-NSOT_region1.id}"]
    subnet_id = "${aws_subnet.us-west-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    iam_instance_profile = "${aws_iam_instance_profile.cosmos_instance_profile.name}"
    tags {
        Name = "cosmos-NSOT-TF"
    }

    provisioner "remote-exec" {
        inline = [
           "echo Y | sudo apt-get update",
           "echo Y | sudo apt-get -y install build-essential python-dev libffi-dev libssl-dev",
           "echo Y | sudo apt-get --yes install python-pip git",
           "wget https://pypi.python.org/packages/40/9b/0bc869f290b8f49a99b8d97927f57126a5d1befcf8bac92c60dc855f2523/mysqlclient-1.3.10.tar.gz#md5=e7fb95c4055e2d8a3322db5c85ab6fc8",
           "echo Y | sudo apt-get install nsot",
           "sudo nsot-server init",
         "sudo aws ec2 authorize-security-group-ingress --group-id ${aws_security_group.cosmos-NSOT_region1.id} --protocol tcp --port 22 --cidr 203.0.113.0/24 --region us-west-2"
      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }

  }

 