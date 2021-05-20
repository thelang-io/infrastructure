#
# Copyright (c) Aaron Delasy
#
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
#

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

resource "aws_security_group" "api" {
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

resource "aws_instance" "api" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_pair_name
  user_data              = file("api-init.sh")
  vpc_security_group_ids = [aws_security_group.api.id]

  tags = {
    Name = "the-api"
  }
}

resource "aws_eip_association" "api" {
  allow_reassociation = false
  instance_id         = aws_instance.api.id
  allocation_id       = var.eip_allocation_id
}
