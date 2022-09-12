#!/usr/bin/env bash

#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

set -ex

apt-get update -y

curl -L https://deb.nodesource.com/setup_lts.x | bash
apt-get install -y build-essential cmake nginx nodejs

npm install -g pm2
pm2 startup -u ubuntu --hp /home/ubuntu

mkdir -p /app
# todo configure nginx, ssl with cert manager on AWS
