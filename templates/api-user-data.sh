#!/bin/bash -ex

#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

apt-get update -y
apt-get upgrade -y
curl -L https://deb.nodesource.com/setup_lts.x | bash
apt-get install -y nodejs
npm install -g pm2
pm2 startup -u ubuntu --hp /home/ubuntu
mkdir -p /app
printf "%s" "${ecosystem_config_content}" > /ecosystem.config.js
reboot
