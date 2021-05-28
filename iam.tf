#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_iam_policy_document" "code_build_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "code_build" {
  name               = "aws-codebuild-the-api-service-role"
  assume_role_policy = data.aws_iam_policy_document.code_build_role.json
}
