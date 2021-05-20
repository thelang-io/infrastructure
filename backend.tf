#
# Copyright (c) Aaron Delasy
#
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
#

terraform {
  backend "s3" {
    bucket  = "private.thelang.io"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
