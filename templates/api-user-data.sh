#!/usr/bin/env bash

#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

set -ex

apt-get update -y

curl -L https://deb.nodesource.com/setup_lts.x | bash
apt-get install -y build-essential certbot clang cmake nginx nodejs python3-certbot-nginx

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

apt-get install -y mingw-w64 libssl-dev lzma-dev libxml2-dev llvm-dev

sudo -u ubuntu -i << EOF
git clone https://github.com/tpoechtrager/osxcross.git /home/ubuntu/osxcross/
curl http://cdn.delasy.com.s3-website.eu-central-1.amazonaws.com/MacOSX12.3.sdk.tar.xz \
  -o /home/ubuntu/osxcross/tarballs/MacOSX12.3.sdk.tar.xz
echo "PATH=\"\$HOME/osxcross/target/bin:\$PATH\"" >> /home/ubuntu/.profile
UNATTENDED=1 nohup bash -c "/home/ubuntu/osxcross/build.sh > /home/ubuntu/osxcross-build.log 2>&1" > /dev/null 2>&1 &
EOF
