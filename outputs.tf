#
# Copyright (c) Aaron Delasy
#
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
#

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.the-api-ec2.id
}
