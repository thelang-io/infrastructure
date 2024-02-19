#!/bin/sh

#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

set -ex

curl -fsSL https://deb.nodesource.com/setup_lts.x | bash

apt-get update -y
apt-get install -y build-essential certbot clang cmake mingw-w64 nginx nodejs python3-certbot-nginx

mkdir -p /app
chown -R ubuntu:ubuntu /app

git config --system advice.detachedHead false
npm install -g pm2
pm2 startup -u ubuntu --hp /home/ubuntu

cat > /etc/nginx/sites-available/api.thelang.io << EOF
server {
  listen 80;
  listen [::]:80;
  root /var/www/html;
  index index.html index.htm index.nginx-debian.html;
  server_name api.thelang.io;
  client_max_body_size 200M;
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
  }
}
EOF

ln -sf /etc/nginx/sites-available/api.thelang.io /etc/nginx/sites-enabled/
sed -e 's/# server_tokens off;/server_tokens off;/' -i /etc/nginx/nginx.conf
systemctl restart nginx
certbot --nginx --agree-tos --redirect -d api.thelang.io -m support@thelang.io -n

curl -fsSL https://cdn.thelang.io/deps.tar.gz | tar -C /usr/local -xz
su - ubuntu -c "curl -fsSL https://cdn.thelang.io/cli | bash"

sed -e 's|PATH="\(.*\)"|PATH="/usr/local/the/osxcross/bin:\1"|g' -i /etc/environment
sed -e 's/#define _WIN32_WINNT .*/#define _WIN32_WINNT 0x0A00/' -i /usr/share/mingw-w64/include/_mingw.h
