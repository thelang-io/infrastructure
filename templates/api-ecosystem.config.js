module.exports = {
  apps: [{
    name: 'api',
    cwd: '/app',
    script: 'api.js',
    env: {
      NODE_ENV: 'production',
      PORT: '8080'
    }
  }]
}
