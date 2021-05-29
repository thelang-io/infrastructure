#!/bin/bash -ex

#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

apt-get update -y
apt-get upgrade -y

curl -L https://deb.nodesource.com/setup_lts.x | bash
apt-get install -y nodejs ruby-full
curl -L https://aws-codedeploy-eu-central-1.s3.eu-central-1.amazonaws.com/latest/install -o install
chmod +x install
./install auto

mkdir -p /app
npm install -g pm2
pm2 startup -u ubuntu --hp /home/ubuntu

cat << EOF > /ecosystem.config.js
module.exports = {
  apps : [{
    name: 'app',
    cwd: '/app',
    script: 'app.js',
    env: {
      NODE_ENV: 'production',
      PORT: '8080'
    }
  }]
}
EOF
