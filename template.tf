#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

data "template_file" "api_build_buildspec" {
  template = file("templates/api-build-buildspec.yml")

  vars = {
    appspec_content      = replace(file("templates/api-appspec.yml"), "\n", "\\n")
    start_script_content = replace(file("templates/api-start.sh"), "\n", "\\n")
  }
}

data "template_file" "api_test_buildspec" {
  template = file("templates/api-test-buildspec.yml")
}

data "template_file" "api_user_data" {
  template = file("templates/api-user-data.sh")

  vars = {
    ecosystem_config_content = replace(file("templates/api-ecosystem.config.js"), "\n", "\\n")
  }
}
