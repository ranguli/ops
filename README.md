# ops
Terraform and Ansible stuff for provisioning/deploying infrastructure for my personal projects

## Overview

### Packer 
The `build.json` file describes an AMI (sort of like a virtual machine image but for AWS). Here we describe all the basics of an AMI built off of an Amazon Linux 2 base instance with software provisioned by Ansible.

Define some variables for Packer

```json
{
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    "region": "ca-central-1" },
```

The important bits define the instance type and name. 

```
  "builders": [{
      "type": "amazon-ebs",
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key`}}", 
      "instance_type": "t2.micro",
      "region": "{{user `region`}}",
      "ssh_username": "ec2-user",
      "source_ami": "ami-0ff24797826ebbcd5",
      "ami_name": "packer-prod"
  }],
```

The provisioner is set to run an Ansible playbook.

```
  "provisioners": [{
      "type": "ansible",
      "playbook_file": "./playbook.yml"
  }]
}
```

### Ansible
The `playbook.yml` file is run by Packer. TL;DR it installs a bunch of
packages and performs system configuration that will then be baked into the AMI
base image. The tradeoff is that we increase the size of the base image in
exchange for time saved in not having to install packages everytime we create
an instance via Terraform. 

```
  tasks:
    - name: Install yum packages 
      become: true
      yum:
        update_cache: yes

    - name: Install Docker Amazon Linux 2
      become: true
      shell: amazon-linux-extras install docker

    - name: Make sure docker service is running
      become: true
      systemd:
        name: docker
        state: started
        enabled: yes

    - name: Add the ec2-user to the Docker group
      become: true
      user:
        name: ec2-user
        groups: docker
```

### Terraform 
The `main.tf` file is run by Terraform. While Packer describes a base image,
and Ansible describes a state of installed software and system configs,
Terraform describes a state of resources in AWS, like EC2 instances and
security groups.

Terraform supports multiple "providers", like AWS, Azure, etc.

```
provider "aws" {
  region = "ca-central-1"
}
```

Here we define an EC2 instance that uses the AMI we created with Packer.

```
resource "aws_instance" "prod" {
  ami = "${data.aws_ami.packer-prod.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  tags = {
    Name = "ec2-prod"
  }
}
```

This definition is how we explain to Terraform which AMI to use.

```
data "aws_ami" "packer-prod" {
  owners = ["self"]
  most_recent = true

  filter {
    name = "name"
    values = ["packer-prod"]
  }
}
```

Lastly, create a security group, assign it a name. This isn't hugely 
secure, by the way!

```
resource "aws_security_group" "instance" {
  name = "ec2-prod"
  
  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
