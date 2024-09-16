#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

resource "cloudflare_record" "api" {
  depends_on = [aws_instance.api]

  name    = "api"
  type    = "A"
  zone_id = data.cloudflare_zone.thelang.id
  content = aws_instance.api.public_ip
  proxied = true
}

resource "cloudflare_record" "ci" {
  depends_on = [aws_instance.ci]

  name    = "ci"
  type    = "A"
  zone_id = data.cloudflare_zone.thelang.id
  content = aws_instance.ci.public_ip
  proxied = true
}
