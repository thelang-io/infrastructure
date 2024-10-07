#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

# resource "cloudflare_record" "api" {
#   name    = "api"
#   type    = "A"
#   zone_id = data.cloudflare_zone.thelang.id
#   content = aws_eip.api.public_ip
#   proxied = true
# }
#
# resource "cloudflare_record" "ci" {
#   name    = "ci"
#   type    = "A"
#   zone_id = data.cloudflare_zone.thelang.id
#   content = aws_eip.ci.public_ip
#   proxied = true
# }
