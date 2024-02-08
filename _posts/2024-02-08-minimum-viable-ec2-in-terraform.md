---
layout: post
title: "Minimum Viable EC2 in Terraform"
date: 2024-02-08
---
The Terraform AWS tutorial will have you create an EC2 instance with just a few lines of configuration that look something like this:

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
```

This is nice for new users that are just learning the basics of how the Terraform config language works. However this is essentially just a toy EC2 instance. It's configuration is obviously not something you'd want in any production environment, and it isn't really anything you'd want in a testing or dev environment either. For one thing, this EC2 instance is just going to connect to the region's default VPC. That is not something you want to do in Terraform because Terraform cannot modify the default VPC, it can only read changes to its state, which defeats the purpose of Infrastructure as Code (IaC). Additionally the default VPC doesn't support ipv6 addresses. Ipv6 has been around for a long time, but the default behavior of most engineers has been to look at how to manage ipv6, and then proceed to ignore it. That is starting to change now that cloud providers like AWS are charging much higher rates for ipv4 addresses. Regardless of where you are in your journey with working with ipv6, you probably don't want to be locked into only being able to work with ipv4. So the default VPC is a non-starter. But once you create your own VPC resource that you associate with an EC2 instance you instantly create a lot of extra complexity. This is what your config file will look like at the end when you create the necessary resources to have an EC2 instance connected to your VPC that you can ssh into, and can accept HTTP and HTTPS requests.

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# resource "aws_key_pair" "my_instance_key" {
#  key_name   = "my_ssh_key"
#}

resource "aws_vpc" "my_instance_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "my_instance_igw" {
  vpc_id = aws_vpc.my_instance_vpc.id
}

resource "aws_subnet" "my_instance_subnet" {
  vpc_id            = aws_vpc.my_instance_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_route_table" "my_instance_rtb" {
  vpc_id = aws_vpc.my_instance_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_instance_igw.id
  }
}

resource "aws_route_table_association" "my_instance_rta" {
  subnet_id      = aws_subnet.my_instance_subnet.id
  route_table_id = aws_route_table.my_instance_rtb.id
}

resource "aws_security_group" "my_instance_sg" {
  name   = "my_instance_sg"
  vpc_id = aws_vpc.my_instance_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  key_name                    = "my_ssh_key"
  ami                         = "ami-058bd2d568351da34"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.my_instance_sg.id]
  subnet_id                   = aws_subnet.my_instance_subnet.id
  associate_public_ip_address = true
}
```

Also note I omitted tagging for brevity's sake, but you would want to include tagging as well. This is a pretty substantial leap. We've gone from 23 lines of code to 86. Lets go over these resources.

### VPC

Our VPC resource defines a CIDR block, and also sets `enable_dns_support`, and `enable_dns_hostnames` to `true`. It is intuitive enough that you need a CIDR block if you want to expose a public IP address. It is less intuitive that you would need to enable the DNS values, but it turns out you'll run into connection problems without those values.

### Internet Gateway

This is a VPC component that enables the internet traffic between your VPC and the internet, per [the docs](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html). The only thing you need to do here is associate it with the VPC you created.

### Subnet

The subnet defines the range of IP addresses available on your VPC. The important thing here is we will define a specific availability zone for our subnet, and later when we define the config for our EC2 resource, we'll associate it with the subnet ID. Note that there are some subtletys with regard to whether you have an IPv4 or IPv6 subnet. I'm hoping to cover that in a future post at some point.

### Route Table

Okay, so the Internet Gateway connects to the internet for your VPC, but we use a route table resource to connect that internet traffic from the gateway to the VPC...

### Route Table Association

... And then on top of that we have a route table association that connects our subnet to the route table. Everything is just a bunch of glue!

### Security Group

This is the firewall for your VPC. This is a pretty standard definition for any public facing instance you might deploy as it opens up incoming TCP traffic on ports 22, 80, and 443 (SSH, HTTP, and HTTPS respectively), and allows all outgoing traffic. You might add some custom ports as well if you have some backend services that listen in on other ports.

### EC2 Instance

Finally there is the EC2 instance. Besides defining the AMI ID being used and the instance size, we also define the VPC security group, and subnet ID used by the instance. Finally, and this is the most important thing to include, we set `associate_public_ip_address` to `true`. If you don't do that you won't have an easy way to ssh into your new instance once it is provisioned.
