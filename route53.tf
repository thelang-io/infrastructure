#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_route53_zone" "api" {
  name = "api.thelang.io"
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.api.zone_id
  name    = "api.thelang.io"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.api.public_ip]
}
