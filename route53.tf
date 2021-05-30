#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_route53_zone" "primary" {
  name = "thelang.io"
}

resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "thelang.io"
  type    = "A"
  ttl     = "300"

  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "api.thelang.io"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.api.public_ip]
}
