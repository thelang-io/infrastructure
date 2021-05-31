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
