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



resource "aws_security_group" "cosmos-vrouter_region1" {
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


    vpc_id = "${aws_vpc.cosmos-vrouter-edgerouter-region1-vpc.id}"

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
         "echo Y | sudo apt-get install python-pip",
         "echo Y | sudo apt-get install awscli",
         "echo Y | sudo apt-get install docker.io",
         "echo ${aws_security_group.cosmos-vrouter_region1.id} >> test",
         "instance_profile=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/`",
         "echo $instance_profile /"AWS/"",
         "aws_access_key_id=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep AccessKeyId | cut -d':' -f2 | sed 's/[^0-9A-Z]*//g'`",
         "echo $aws_access_key_id /"AWS/"",
         "aws_secret_access_key=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep SecretAccessKey | cut -d':' -f2 | sed 's/[^0-9A-Za-z/+=]*//g'`",
        "echo $aws_secret_access_key /"AWS/"",
         "export AWS_ACCESS_KEY_ID=${aws_access_key_id}",
         "echo $AWS_ACCESS_KEY_ID /"AWS/"",
         "export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}",
         "echo $AWS_SECRET_ACCESS_KEY /"AWS/""
         "sudo aws ec2 authorize-security-group-ingress --group-name my-sg ${aws_security_group.cosmos-vrouter_region1.name} --protocol tcp --port 22 --cidr 203.0.113.0/24",
         "sudo docker login -e jeremiah.gearheart@pearson.com -u _json_key -p \"$(cat gcrtest.json)\" https://gcr.io",
         "sudo docker pull gcr.io/pearson-techops/cosmos/vrouter:COS-175",
         "sudo docker run --net host --privileged -e USERNAME=${var.USERNAME} -e PASSWORD=${var.PASSWORD} -e ETCD_DISCOVER=discover.blue-etcd.shared.prsn-dev.io --name vrouter -itd gcr.io/pearson-techops/cosmos/vrouter:COS-175",
         "HOSTNAME=$(hostname | tr - _)",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/routetableid -d value=\"${aws_route_table.us-west-2a-public.id}\"",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/cidrblock -d value=\"${aws_subnet.us-west-2a-public.cidr_block}\"",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/securitygroup -d value=\"${aws_security_group.cosmos-vrouter_region1.id}\"",
         "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/publicip -d value=\"${aws_instance.cosmos-vrouter.public_ip}\""

      ]
  }
  connection {
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }
  }

  resource "aws_instance" "cosmos-testbox-region1" {
      provider = "aws.oregon"
      ami = "${var.ami_region1}"
      availability_zone = "us-west-2a"
      instance_type = "t2.small"
      key_name = "${aws_key_pair.cosmos-admin.key_name}"
      vpc_security_group_ids = ["${aws_security_group.cosmos-vrouter_region1.id}"]
      subnet_id = "${aws_subnet.us-west-2a-public.id}"
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

#------------------------------------------    
#Vrouter Region2
#------------------------------------------

  resource "aws_security_group" "cosmos_vrouter_region2" {
      provider = "aws.ohio"
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


      vpc_id = "${aws_vpc.cosmos-vrouter-edgerouter-region2-vpc.id}"

      tags {
          Name = "cosmos-vrouter-SG"
      }
  }
  resource "aws_key_pair" "cosmos-admin_region2" {
    provider = "aws.ohio"
    key_name = "cosmos-admin3"
    public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
  }

  resource "aws_instance" "cosmos-vrouter-region2" {
      provider = "aws.ohio"
      count = "${var.requirevrouter}"
      ami = "${var.ami_region2}"
      availability_zone = "us-east-2a"
      instance_type = "t2.small"
      key_name = "${aws_key_pair.cosmos-admin_region2.key_name}"
      vpc_security_group_ids = ["${aws_security_group.cosmos_vrouter_region2.id}"]
      subnet_id = "${aws_subnet.us-east-2a-public.id}"
      associate_public_ip_address = true
      source_dest_check = false


      tags {
          Name = "cosmos-vrouter-TF"
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
           "echo ${aws_security_group.cosmos_vrouter_region2.id} >> test",
           "sudo docker login -e jeremiah.gearheart@pearson.com -u _json_key -p \"$(cat gcrtest.json)\" https://gcr.io",
           "sudo docker pull gcr.io/pearson-techops/cosmos/vrouter:COS-175",
           "sudo docker run --net host --privileged -e USERNAME=${var.USERNAME} -e PASSWORD=${var.PASSWORD} -e ETCD_DISCOVER=discover.blue-etcd.shared.prsn-dev.io --name vrouter -itd gcr.io/pearson-techops/cosmos/vrouter:COS-175",
           "HOSTNAME=$(hostname | tr - _)",
          "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/routetableid -d value=\"${aws_route_table.us-east-2a-public.id}\"",
          "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/cidrblock -d value=\"${aws_subnet.us-east-2a-public.cidr_block}\"",
          "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/securitygroup -d value=\"${aws_security_group.cosmos_vrouter_region2.id}\"",
          "curl -X PUT http://ec2-52-9-39-36.us-west-1.compute.amazonaws.com:2379/v2/keys/$HOSTNAME/publicip -d value=\"${aws_instance.cosmos-vrouter-region2.public_ip}\""

        ]
    }
    connection {
        user = "${var.INSTANCE_USERNAME}"
        private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
      }
    }

    resource "aws_instance" "cosmos-testbox-region2" {
        provider = "aws.ohio"
        count = "${var.requirevrouter}"
        ami = "${var.ami_region2}"
        availability_zone = "us-east-2a"
        instance_type = "t2.small"
        key_name = "${aws_key_pair.cosmos-admin_region2.key_name}"
        vpc_security_group_ids = ["${aws_security_group.cosmos_vrouter_region2.id}"]
        subnet_id = "${aws_subnet.us-east-2a-public.id}"
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
  provider = "aws.oregon"
  route_table_id = "${aws_route_table_association.us-west-2a-public.route_table_id}"
  destination_cidr_block = "${aws_vpc.cosmos-vrouter-edgerouter-region2-vpc.cidr_block}"
  instance_id = "${aws_instance.cosmos-vrouter.id}"
}


resource "aws_route" "route2" {
  provider = "aws.ohio"
  route_table_id = "${aws_route_table_association.us-east-2a-public.route_table_id}"
  destination_cidr_block = "${aws_vpc.cosmos-vrouter-edgerouter-region1-vpc.cidr_block}"
  instance_id = "${aws_instance.cosmos-vrouter-region2.id}"
}

#output "Region1 Vouter Public IP:" {
#  value = "${aws_instance.cosmos-vrouter-region1.public_ip}"
#}

#output "Region2 Vouter Public IP:" {
#  value = "${aws_instance.cosmos-vrouter-region2.public_ip}"
#}



