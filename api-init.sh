#!/bin/bash
apt update -y
apt upgrade -y
apt install -y build-essential nginx python3-certbot python3-certbot-nginx
curl -L https://git.io/n-install | bash
n lts
