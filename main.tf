provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "prod" {
  ami = "${data.aws_ami.packer-prod.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.ec2-prod.id}"]

  tags = {
    Name = "ec2-prod"
  }
}

data "aws_ami" "packer-prod" {
  owners = ["self"]
  most_recent = true

  filter {
    name = "name"
    values = ["packer-prod"]
  }
}

resource "aws_security_group" "ec2-prod" {
  name = "ec2-prod"
  
  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "vpc-prod" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-prod"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc-prod.id}"

  tags = {
    Name = "ig-prod"
  }
}
