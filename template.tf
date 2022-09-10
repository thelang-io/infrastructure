#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

data "template_file" "api_appspec" {
  template = file("templates/api-appspec.yml")
}

data "template_file" "api_build_buildspec" {
  template = file("templates/api-build-buildspec.yml")

  vars = {
    appspec_content      = replace(data.template_file.api_appspec.rendered, "\n", "\\n")
    start_script_content = replace(data.template_file.api_start_script.rendered, "\n", "\\n")
  }
}

data "template_file" "api_ecosystem_config" {
  template = file("templates/api-ecosystem.config.js")

  vars = {
    auth_token = var.auth_token
  }
}

data "template_file" "api_start_script" {
  template = file("templates/api-start.sh")
}

data "template_file" "api_test_buildspec" {
  template = file("templates/api-test-buildspec.yml")
}

data "template_file" "api_user_data" {
  template = file("templates/api-user-data.sh")

  vars = {
    ecosystem_config_content = replace(data.template_file.api_ecosystem_config.rendered, "\n", "\\n")
  }
}
