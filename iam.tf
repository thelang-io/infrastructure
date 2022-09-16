#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_iam_policy_document" "s3_cdn" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${data.aws_route53_zone.cdn.name}/*"
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
      ]
    }
  }
}
