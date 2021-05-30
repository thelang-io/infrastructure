#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_iam_policy" "aws_code_build_developer" {
  arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

data "aws_iam_policy" "aws_code_deploy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

data "aws_iam_policy" "aws_code_pipeline_full" {
  arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

data "aws_iam_policy" "aws_ec2_for_code_deploy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

data "aws_iam_policy" "aws_s3_readonly" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy" "aws_ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

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

data "aws_iam_policy_document" "code_pipeline_role_policy" {
  statement {
    actions   = ["codebuild:BatchGetBuilds", "codebuild:StartBuild"]
    resources = ["*"]
  }

  statement {
    actions   = ["codestar-connections:UseConnection"]
    resources = [data.aws_codestarconnections_connection.langthe.arn]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject"
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

resource "aws_iam_role_policy" "code_pipeline" {
  name   = "CodePipelineRolePolicy"
  role   = aws_iam_role.code_pipeline.id
  policy = data.aws_iam_policy_document.code_pipeline_role_policy.json
}

resource "aws_iam_role_policy_attachment" "aws_code_build_developer" {
  role       = aws_iam_role.code_build.name
  policy_arn = data.aws_iam_policy.aws_code_build_developer.arn
}

resource "aws_iam_role_policy_attachment" "aws_code_build_s3_readonly" {
  role       = aws_iam_role.code_build.name
  policy_arn = data.aws_iam_policy.aws_s3_readonly.arn
}

resource "aws_iam_role_policy_attachment" "aws_code_deploy" {
  role       = aws_iam_role.code_deploy.name
  policy_arn = data.aws_iam_policy.aws_code_deploy.arn
}

resource "aws_iam_role_policy_attachment" "code_deploy_ec2" {
  role       = aws_iam_role.code_deploy_ec2.name
  policy_arn = data.aws_iam_policy.aws_ec2_for_code_deploy.arn
}

resource "aws_iam_role_policy_attachment" "code_deploy_ec2_ssm_managed_instance_core" {
  role       = aws_iam_role.code_deploy_ec2.name
  policy_arn = data.aws_iam_policy.aws_ssm_managed_instance_core.arn
}

resource "aws_iam_role_policy_attachment" "code_pipeline_full" {
  role       = aws_iam_role.code_pipeline.name
  policy_arn = data.aws_iam_policy.aws_code_pipeline_full.arn
  depends_on = [aws_iam_role_policy.code_pipeline]
}

resource "aws_iam_instance_profile" "code_deploy_ec2" {
  name = "CodeDeployEC2InstanceProfile"
  role = aws_iam_role.code_deploy_ec2.name

  depends_on = [
    aws_iam_role_policy_attachment.code_deploy_ec2,
    aws_iam_role_policy_attachment.code_deploy_ec2_ssm_managed_instance_core
  ]
}
