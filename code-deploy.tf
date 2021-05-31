#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_codedeploy_app" "api" {
  compute_platform = "Server"
  name             = "the-api-codedeploy"
}

resource "aws_codedeploy_deployment_group" "api" {
  app_name              = aws_codedeploy_app.api.name
  deployment_group_name = "the-api-codedeploy-group"
  service_role_arn      = aws_iam_role.code_deploy.arn
  depends_on            = [aws_iam_role_policy.code_deploy]

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "the-api"
    }
  }
}
