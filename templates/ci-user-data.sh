#!/bin/sh

#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

set -ex

curl -fsSL https://deb.nodesource.com/setup_lts.x | bash
curl -fsSL https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/setup.deb.sh | bash
curl -fsSL https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/setup.deb.sh | bash

apt-get update -y
apt-get install -y build-essential certbot clang cmake erlang nginx nodejs python3-certbot-nginx rabbitmq-server

mkdir -p /app
chown -R ubuntu:ubuntu /app

git config --system advice.detachedHead false
npm install -g pm2
pm2 startup -u ubuntu --hp /home/ubuntu

cat > /etc/nginx/sites-available/ci.thelang.io << EOF
server {
  listen 80;
  listen [::]:80;
  root /var/www/html;
  index index.html index.htm index.nginx-debian.html;
  server_name ci.thelang.io;
  location / {
    proxy_pass http://localhost:8080;
    proxy_http_version 1.1;
    proxy_cache_bypass \$http_upgrade;
    proxy_redirect off;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Host \$host;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Real-IP \$remote_addr;
  }
}
EOF

ln -sf /etc/nginx/sites-available/ci.thelang.io /etc/nginx/sites-enabled/
systemctl restart nginx
certbot --nginx --agree-tos --no-redirect -d ci.thelang.io -m support@thelang.io -n

curl -fsSL https://cdn.thelang.io/deps.tar.gz | tar -C /usr/local -xz
