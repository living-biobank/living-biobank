process.env.NODE_ENV = process.env.NODE_ENV || 'testing'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()
