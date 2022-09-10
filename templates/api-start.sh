#!/bin/bash -ex

#
# Copyright (c) 2018-present Aaron Delasy
# Licensed under the MIT License
#

pm2 start /ecosystem.config.js
pm2 save
