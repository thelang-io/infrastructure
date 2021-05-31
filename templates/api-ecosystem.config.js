//
// Copyright (c) 2021-present Aaron Delasy
// Licensed under the MIT License
//

module.exports = {
  apps: [{
    name: 'api',
    cwd: '/app',
    script: 'api.js',
    env: {
      AUTH_TOKEN: '${auth_token}',
      NODE_ENV: 'production',
      PORT: '8080'
    }
  }]
}
