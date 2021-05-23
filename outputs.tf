#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.api.id
}
