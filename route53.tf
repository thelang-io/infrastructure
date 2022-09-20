#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_route53_zone" "api" {
  name = "api.thelang.io"
}

data "aws_route53_zone" "cdn" {
  name = "cdn.thelang.io"
}

resource "aws_route53_record" "api" {
  depends_on = [aws_instance.api]

  zone_id = data.aws_route53_zone.api.zone_id
  name    = "api.thelang.io"
  type    = "A"
  ttl     = "3600"
  records = [aws_instance.api.public_ip]
}

resource "aws_route53_record" "cdn" {
  zone_id = data.aws_route53_zone.cdn.zone_id
  name    = "cdn.thelang.io"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cdn_cert_validation" {
  name    = tolist(aws_acm_certificate.cdn.domain_validation_options).0.resource_record_name
  type    = tolist(aws_acm_certificate.cdn.domain_validation_options).0.resource_record_type
  zone_id = data.aws_route53_zone.cdn.id
  records = [tolist(aws_acm_certificate.cdn.domain_validation_options).0.resource_record_value]
  ttl     = 60
}
