require 'configuration'

environment = Goliath.env.to_s
config[:db] = ::Sequel.connect(Configuration.database[environment].merge(
  max_connections: 10
))

require 'models/content'
