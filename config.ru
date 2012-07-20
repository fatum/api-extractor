# config.ru
$: << File.expand_path(File.dirname(__FILE__))

require 'extractor'
run Sinatra::Application
