provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "prod" {
  ami = "${data.aws_ami.packer-prod.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

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

resource "aws_security_group" "instance" {
  name = "ec2-prod"
  
  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
