#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_s3_bucket" "private" {
  bucket = "the-private"
}
