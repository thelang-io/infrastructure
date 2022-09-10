#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_security_group" "public" {
  name = "public"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

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
}

resource "aws_instance" "api" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.code_deploy_ec2.name
  key_name               = "MacBook Pro (13-inch, 2018)"
  user_data              = data.template_file.api_user_data.rendered
  vpc_security_group_ids = [aws_security_group.public.id]

  tags = {
    Name = "the-api"
  }
}
