#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

terraform {
  backend "s3" {
    bucket  = "private.thelang.io"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
