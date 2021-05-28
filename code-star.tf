#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_codestarconnections_connection" "langthe" {
  arn = var.code_star_connection_arn
}
