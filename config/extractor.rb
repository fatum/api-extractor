environment :development do
  require 'logger'
  config[:db_settings] = {
    username: "maxfilipovich",
    password: "",
    host: "localhost",
    database: "extractor_development",
    adapter: "postgres",
    logger: Logger.new(STDOUT)
  }
end

environment :test do
  config[:db_settings] = {
    username: "maxfilipovich",
    password: "",
    host: "localhost",
    database: "extractor_test",
    adapter: "postgres"
  }
end

import('db')
