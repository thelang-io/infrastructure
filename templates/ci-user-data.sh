#!/bin/sh

#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

set -ex

apt-get update -y
apt-get install -y build-essential curl gpg
curl -fsSL https://cdn.thelang.io/deps.tar.gz | tar -C /usr/local -xz

# Install Certbot
snap install core
snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

# Install Clang
curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
add-apt-repository -y "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-18 main"
apt-get install -y clang-18 lldb-18 lld-18 clangd-18
ln -s /usr/bin/clang-18 /usr/bin/clang
ln -s /usr/bin/clangd-18 /usr/bin/clangd
ln -s /usr/bin/clang++-18 /usr/bin/clang++
ln -s /usr/bin/clang-cpp-18 /usr/bin/clang-cpp

# Install CMake
curl -fsSL https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
  gpg --dearmor - | \
  tee /etc/apt/trusted.gpg.d/apt.kitware.com.gpg >/dev/null

apt-add-repository -y "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
apt-get install -y cmake

# Install Erlang
curl -fsSL https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/setup.deb.sh | bash
apt-get install -y erlang

# Install Nginx
apt-get install -y nginx

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_22.x | bash
apt-get install -y nodejs

# Install RabbitMQ
curl -fsSL https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/setup.deb.sh | bash
apt-get install -y rabbitmq-server

# Install The
curl -fsSL sh.thelang.io | bash

mkdir -p /app
chown -R ubuntu:ubuntu /app

git config --system advice.detachedHead false
npm install -g pm2
pm2 startup -u ubuntu --hp /home/ubuntu

git clone --branch main --depth 1 https://github.com/thelang-io/ci.thelang.io.git
cp ci.thelang.io/devops/nginx.conf /etc/nginx/sites-available/ci.thelang.io
rm -rf ci.thelang.io

ln -sf /etc/nginx/sites-available/ci.thelang.io /etc/nginx/sites-enabled/
sed -e 's/# server_tokens off;/server_tokens off;/' -i /etc/nginx/nginx.conf
systemctl restart nginx
certbot --nginx --agree-tos --no-redirect -d ci.thelang.io -m support@thelang.io -n
