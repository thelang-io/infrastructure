#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

data "http" "ip" {
  url = "http://ipv4.icanhazip.com"
}
