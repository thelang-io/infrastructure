module.exports = {
  apps: [{
    name: 'app',
    cwd: '/app',
    script: 'app.js',
    env: {
      NODE_ENV: 'production',
      PORT: '8080'
    }
  }]
}
