#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_codebuild_project" "api_build" {
  name         = "the-api-build"
  service_role = aws_iam_role.code_build.arn

  depends_on = [
    aws_iam_role_policy_attachment.aws_code_build_admin,
    aws_iam_role_policy_attachment.aws_code_build_s3_readonly
  ]

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = data.template_file.api_build_buildspec.rendered
    git_clone_depth = 1
  }
}

resource "aws_codebuild_project" "api_test" {
  name         = "the-api-test"
  service_role = aws_iam_role.code_build.arn

  depends_on = [
    aws_iam_role_policy_attachment.aws_code_build_admin,
    aws_iam_role_policy_attachment.aws_code_build_s3_readonly
  ]

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = data.template_file.api_test_buildspec.rendered
    git_clone_depth = 1
  }
}
