#!/bin/bash -ex

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
