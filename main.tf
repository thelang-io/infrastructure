#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

#
# Before using:
#  1. Create Access Key
#  2. Create S3 bucket "the-private"
#  3. Create DynamoDB table "the-private" with key "LockID"
#  4. Create CodeStar connection
#

terraform {
  backend "s3" {
    bucket         = "the-private"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "the-private"
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
  region  = "us-east-1"
}
