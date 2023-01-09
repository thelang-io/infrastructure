#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

data "template_file" "api_user_data" {
  template = file("templates/api-user-data.sh")
}

data "template_file" "ci_user_data" {
  template = file("templates/ci-user-data.sh")
}
