#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_s3_bucket" "private" {
  bucket = "the-private"
}
