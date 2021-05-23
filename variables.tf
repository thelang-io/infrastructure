#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

variable "eip_allocation_id" {
  description = "Value of the allocation id for Elastic IP address"
  type        = string
}

variable "key_pair_name" {
  description = "Value of the key pair name for EC2 instance"
  type        = string
}
