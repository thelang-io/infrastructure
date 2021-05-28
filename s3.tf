#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_s3_bucket" "code_pipeline" {
  bucket        = "code-pipeline"
  acl           = "private"
  force_destroy = true
}
