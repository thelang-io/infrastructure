#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

data "aws_s3_bucket" "private" {
  bucket = "the-private"
}

resource "aws_s3_bucket" "cdn" {
  bucket = data.aws_route53_zone.cdn.name
}

resource "aws_s3_bucket_acl" "cdn" {
  bucket = aws_s3_bucket.cdn.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.cdn.id
  policy = data.aws_iam_policy_document.s3_cdn.json
}

resource "aws_s3_bucket_versioning" "cdn" {
  bucket = aws_s3_bucket.cdn.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.cdn.id
  key          = "index.html"
  source       = "objects/cdn-index.html"
  content_type = "text/html"
  etag         = filemd5("objects/cdn-index.html")
}
