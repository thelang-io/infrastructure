#!/bin/bash -ex

#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

apt-get update -y
apt-get upgrade -y

curl -L https://deb.nodesource.com/setup_lts.x | bash
apt-get install -y nodejs ruby-full

curl -L https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install -o install
chmod +x ./install
./install auto > /dev/null

npm install -g pm2
pm2 startup -u ubuntu --hp /home/ubuntu

mkdir -p /app
printf "${ecosystem_config_content}" > /ecosystem.config.js
