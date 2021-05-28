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
