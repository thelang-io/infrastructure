#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

# output "ec2_api_ip" {
#   value = aws_eip.api.public_ip
# }

output "ec2_ci_ip" {
  value = aws_eip.ci.public_ip
}
