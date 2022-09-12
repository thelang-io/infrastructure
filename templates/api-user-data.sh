#!/usr/bin/env bash

#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

set -ex

apt-get update -y

curl -L https://deb.nodesource.com/setup_lts.x | bash
apt-get install -y build-essential certbot cmake nginx nodejs python3-certbot-nginx

npm install -g pm2
pm2 startup -u ubuntu --hp /home/ubuntu

cat > /etc/nginx/sites-available/api.thelang.io << EOF
server {
  listen 80;
  listen [::]:80;
  root /var/www/html;
  index index.html index.htm index.nginx-debian.html;
  server_name api.thelang.io;
  location / {
    proxy_pass http://localhost:8080;
    proxy_http_version 1.1;
    proxy_set_header Connection '';
    proxy_set_header Host \$host;
    chunked_transfer_encoding off;
    proxy_buffering off;
    proxy_cache off;
  }
}
EOF

ln -s /etc/nginx/sites-available/api.thelang.io /etc/nginx/sites-enabled/
systemctl restart nginx
certbot --nginx --agree-tos --redirect -d api.thelang.io -m support@thelang.io -n

mkdir -p /app
chown -R ubuntu:ubuntu /app
