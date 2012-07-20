set :environment, ENV['RACK_ENV'] || :development
configure :development do
  set :database, 'postgres://maxfilipovich@localhost/extractor_development'
end

configure :test do
  set :database, 'mysql://test@localhost/extractor_test'
end

configure :production do
  set :database, 'mysql://test@localhost/extractor'
end
