#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_instance" "api" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "MacBook Pro (13-inch, 2018)"
  user_data              = data.template_file.api_user_data.rendered
  vpc_security_group_ids = [aws_security_group.public.id]

  tags = {
    Name = "the-api"
  }
}
