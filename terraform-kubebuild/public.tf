#Create IAM role/policy
/*
resource "aws_iam_role" "kubelab_role" 
{
        name = "kubelab_role"		    
	assume_role_policy = "${file("kubelab_iam_role.json")}"	
}

resource "aws_iam_instance_profile" "kubelab_instance_profile" 
{		   
	name = "kubelab_instance_profile"		    
	roles = ["kubelab_role"]		
}

#Create kubelab IAM policy

resource "aws_iam_role_policy" "kubelab_iam_role_policy" 
{		  
	name = "kubelab_iam_role_policy"		  
	role = "${aws_iam_role.kubelab_role.id}"		  
	policy = "${file("kubelab_iam_role_policy.json")}"
}
*/
resource "aws_security_group" "kubelab_vpc" {
  
    name = "kubelab-sg"
    description = "Allow incoming traffic"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["10.0.0.0/8"]
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
    vpc_id = "${aws_vpc.kubelab_vpc.id}"
    tags {
        Name = "kubelab-SG"
        environment = "kubelab-test"
    }
}
/*
resource "aws_network_interface" "vrouter" {
  subnet_id       = "${aws_subnet.public_a.id}"
  security_groups = ["${aws_security_group.web.id}"]

  attachment {
    instance     = "${aws_instance.kubelab.id}"
    device_index = 1
  }
}

resource "aws_network_interface" "vrouter" {
  subnet_id       = "${aws_subnet.public2.id}"
  security_groups = ["${aws_security_group.kubelab_region1.id}"]
  }

resource "aws_network_interface_attachment" "vrouter" {
    instance     = "${aws_instance.kubelab.id}"
    aws_network_interface_id = "${aws_network_interface.vrouter.id}"
    device_index = 1
  }
*/
data "template_file" "kubbuild_host" {
  template = "${file("kubbuild-host.tpl")}"
}
resource "aws_key_pair" "kubelab-admin" {
  key_name = "kubelab-admin3"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "kubelab_kubbuilder" {
    ami = "${var.ami}"
    availability_zone = "${var.az1}"
    instance_type = "t2.small"
    key_name = "${aws_key_pair.kubelab-admin.key_name}"
    vpc_security_group_ids = ["${aws_security_group.kubelab_vpc.id}"]
    subnet_id = "${aws_subnet.kubminion1_subnet.id}"
    associate_public_ip_address = true
    source_dest_check = false
    iam_instance_profile = "${aws_iam_instance_profile.kubelab_instance_profile.name}"
    tags {
        Name = "kubelab_kubbuilder"
    }
    provisioner "remote-exec" {
        inline = "${.template_file.kubbuild_host.rendered}"
  }
  connection {
      user = "root"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }

  }
