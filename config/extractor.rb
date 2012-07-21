environment :development do
  require 'logger'
  config[:db_settings] = {
    username: "maxfilipovich",
    password: "",
    host: "localhost",
    database: "extractor_development",
    adapter: "mysql2",
    logger: Logger.new(STDOUT)
  }
end

environment :test do
  config[:db_settings] = {
    username: "maxfilipovich",
    password: "",
    host: "localhost",
    database: "extractor_test",
    adapter: "mysql2"
  }
end

import('db')
