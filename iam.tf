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

data "aws_iam_policy_document" "code_deploy_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "code_deploy_ec2_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
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

data "aws_iam_policy_document" "code_build_role_policy" {
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs"
    ]

    resources = ["*"]
  }

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
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      data.aws_s3_bucket.private.arn,
      "${data.aws_s3_bucket.private.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "code_deploy_role_policy" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:TerminateInstances"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      data.aws_s3_bucket.private.arn,
      "${data.aws_s3_bucket.private.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "code_deploy_ec2_role_policy" {
  statement {
    actions = [
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      data.aws_s3_bucket.private.arn,
      "${data.aws_s3_bucket.private.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "code_pipeline_role_policy" {
  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]

    resources = ["*"]
  }

  statement {
    actions   = ["codestar-connections:UseConnection"]
    resources = [data.aws_codestarconnections_connection.langthe.arn]
  }

  statement {
    actions = [
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      data.aws_s3_bucket.private.arn,
      "${data.aws_s3_bucket.private.arn}/*"
    ]
  }
}

resource "aws_iam_role" "code_build" {
  name               = "CodeBuildRole"
  assume_role_policy = data.aws_iam_policy_document.code_build_role.json
}

resource "aws_iam_role" "code_deploy" {
  name               = "CodeDeployRole"
  assume_role_policy = data.aws_iam_policy_document.code_deploy_role.json
}

resource "aws_iam_role" "code_deploy_ec2" {
  name               = "CodeDeployEC2Role"
  assume_role_policy = data.aws_iam_policy_document.code_deploy_ec2_role.json
}

resource "aws_iam_role" "code_pipeline" {
  name               = "CodePipelineRole"
  assume_role_policy = data.aws_iam_policy_document.code_pipeline_role.json
}

resource "aws_iam_role_policy" "code_build" {
  name   = "CodeBuildRolePolicy"
  role   = aws_iam_role.code_build.id
  policy = data.aws_iam_policy_document.code_build_role_policy.json
}

resource "aws_iam_role_policy" "code_deploy" {
  name   = "CodeDeployRolePolicy"
  role   = aws_iam_role.code_deploy.id
  policy = data.aws_iam_policy_document.code_deploy_role_policy.json
}

resource "aws_iam_role_policy" "code_deploy_ec2" {
  name   = "CodeDeployEC2RolePolicy"
  role   = aws_iam_role.code_deploy_ec2.id
  policy = data.aws_iam_policy_document.code_deploy_ec2_role_policy.json
}

resource "aws_iam_role_policy" "code_pipeline" {
  name   = "CodePipelineRolePolicy"
  role   = aws_iam_role.code_pipeline.id
  policy = data.aws_iam_policy_document.code_pipeline_role_policy.json
}

resource "aws_iam_instance_profile" "code_deploy_ec2" {
  name       = "CodeDeployEC2InstanceProfile"
  role       = aws_iam_role.code_deploy_ec2.name
  depends_on = [aws_iam_role_policy.code_deploy_ec2]
}
