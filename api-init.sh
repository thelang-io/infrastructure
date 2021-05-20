#!/bin/sh -e
apt-get update -y
apt-get upgrade -y
curl -L https://deb.nodesource.com/setup_lts.x | bash
apt-get install -y build-essential certbot nginx nodejs python3-certbot-nginx
apt-get autoclean
apt-get autoremove
apt-get clean
rm -rf /tmp/* /var/tmp/*
