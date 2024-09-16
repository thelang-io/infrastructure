#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_eip" "api" {
  instance = aws_instance.api.id
  domain   = "vpc"
}

resource "aws_eip" "ci" {
  instance = aws_instance.ci.id
  domain   = "vpc"
}
