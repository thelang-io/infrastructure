#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_acm_certificate" "cdn" {
  domain_name       = data.aws_route53_zone.cdn.name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cdn.arn
  validation_record_fqdns = [aws_route53_record.cdn_cert_validation.fqdn]
}
