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
    keepalive_timeout 120;
  }
}
EOF

ln -s /etc/nginx/sites-available/api.thelang.io /etc/nginx/sites-enabled/
systemctl restart nginx
certbot --nginx --agree-tos --redirect -d api.thelang.io -m support@thelang.io -n

mkdir -p /app
chown -R ubuntu:ubuntu /app

apt-get install -y mingw-w64 libssl-dev lzma-dev libxml2-dev llvm-dev

git config --system advice.detachedHead false
git clone https://github.com/tpoechtrager/osxcross.git /home/ubuntu/osxcross/
curl http://cdn.delasy.com.s3-website.eu-central-1.amazonaws.com/MacOSX12.3.sdk.tar.xz \
  -o /home/ubuntu/osxcross/tarballs/MacOSX12.3.sdk.tar.xz
sed -e 's|PATH="\(.*\)"|PATH="/usr/local/osxcross/bin:\1"|g' -i /etc/environment
echo "OSXCROSS_MP_INC=1" >> /etc/environment

cat << EOF > /home/ubuntu/init.sh
#!/usr/bin/env bash
set -e
TARGET_DIR=/usr/local/osxcross UNATTENDED=1 /home/ubuntu/osxcross/build.sh
export PATH="/usr/local/osxcross/bin:$PATH"
export MACOSX_DEPLOYMENT_TARGET=10.15
export OSXCROSS_MACPORTS_MIRROR=https://packages.macports.org
sed -i 's/\bopenssl rmd160\b/openssl rmd160 -provider legacy/g' /usr/local/osxcross/bin/osxcross-macports
sed -i 's/\bopenssl dgst -ripemd160 -verify\b/openssl dgst -provider default -provider legacy -ripemd160 -verify/g' /usr/local/osxcross/bin/osxcross-macports
osxcross-macports install openssl
ln -sf /usr/local/osxcross/macports/pkgs/opt/local /opt/
EOF

chmod +x /home/ubuntu/init.sh
nohup bash -c "/home/ubuntu/init.sh > /home/ubuntu/osxcross-build.log 2>&1" > /dev/null 2>&1 &
