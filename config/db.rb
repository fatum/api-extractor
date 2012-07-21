config[:db] = ::Sequel.connect(config[:db_settings].merge(
  max_connections: 2
))

require 'models/content'
require 'models/url'
