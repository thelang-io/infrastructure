#!/bin/bash -ex

#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

# Update & Upgrade
apt-get update -y
apt-get upgrade -y

# Install dependencies and clean
curl -L https://deb.nodesource.com/setup_lts.x | bash
apt-get install -y build-essential certbot nginx nodejs python3-certbot-nginx
apt-get autoclean
apt-get autoremove
apt-get clean
rm -rf /tmp/* /var/tmp/*

# Replace default nginx config
rm /etc/nginx/sites-enabled/default
cat > /etc/nginx/sites-available/api.thelang.io << EOF
server {
  listen 80;
  listen [::]:80;
  server_name api.thelang.io;

  root /var/www/html;
  index index.html index.htm index.nginx-debian.html;
}
EOF
ln -sf /etc/nginx/sites-available/api.thelang.io /etc/nginx/sites-enabled/
systemctl restart nginx

# Setup SSL
certbot --agree-tos \
  --nginx \
  --no-eff-email \
  --no-redirect \
  --non-interactive \
  -d api.thelang.io \
  -m press.delasy@gmail.com
cat > /etc/nginx/sites-available/api.thelang.io << EOF
server {
  listen 443 ssl;
  listen [::]:443 ssl ipv6only=on;
  server_name api.thelang.io;

  root /var/www/html;
  index index.html index.htm index.nginx-debian.html;

  ssl_certificate /etc/letsencrypt/live/api.thelang.io/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/api.thelang.io/privkey.pem;
  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

  location / {
    proxy_pass http://localhost:8080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
  }
}

server {
  listen 80;
  listen [::]:80;
  server_name api.thelang.io;

  if (\$host = api.thelang.io) {
    return 301 https://\$host\$request_uri;
  }

  return 404;
}
EOF
sudo systemctl restart nginx
