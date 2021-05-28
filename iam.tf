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

data "aws_iam_policy_document" "code_build_role_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]

    resources = ["*"]
  }

//  statement {
//    actions = ["ec2:CreateNetworkInterfacePermission"]
//    resources = ["arn:aws:ec2:us-east-1:123456789012:network-interface/*"]
//
//    condition {
//      test     = "StringEquals"
//      variable = "ec2:Subnet"
//      values = [aws_subnet.example1.arn, aws_subnet.example2.arn]
//    }
//
//    condition {
//      test     = "StringEquals"
//      variable = "ec2:AuthorizedService"
//      values = [
//        aws_s3_bucket.code_pipeline.arn,
//        "${aws_s3_bucket.code_pipeline.arn}/*"
//      ]
//    }
//  }

  statement {
    actions   = ["s3:*"]

    resources = [
      aws_s3_bucket.code_pipeline.arn,
      "${aws_s3_bucket.code_pipeline.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "code_pipeline_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "code_build" {
  name               = "AWSCodeBuildServiceRole"
  assume_role_policy = data.aws_iam_policy_document.code_build_role.json
}

resource "aws_iam_role_policy" "code_build" {
  name   = "AWSCodeBuildServiceRolePolicy"
  role   = aws_iam_role.code_build.id
  policy = data.aws_iam_policy_document.code_build_role_policy.json
}

resource "aws_iam_role" "code_pipeline" {
  name               = "AWSCodePipelineServiceRole"
  assume_role_policy = data.aws_iam_policy_document.code_pipeline_role.json
}
