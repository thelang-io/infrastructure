terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_security_group" "the-api-sg" {
  name = "the-api-sg"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "the-api"
  }
}

resource "aws_instance" "the-api-ec2" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.the-api-sg.id]

  tags = {
    Name = "the-api"
  }
}
