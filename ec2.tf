#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_instance" "api" {
  ami                         = data.aws_ami.ubuntu-2004.id
  instance_type               = "t2.micro"
  key_name                    = "_"
  user_data                   = data.template_file.api_user_data.rendered
  user_data_replace_on_change = true
  vpc_security_group_ids      = [aws_security_group.public.id]

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "TheAPI"
  }
}

resource "aws_instance" "ci" {
  ami                         = data.aws_ami.ubuntu-2204.id
  instance_type               = "t2.micro"
  key_name                    = "_"
  user_data                   = data.template_file.ci_user_data.rendered
  user_data_replace_on_change = true
  vpc_security_group_ids      = [aws_security_group.public.id]

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "TheCI"
  }
}
