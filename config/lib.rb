require 'addressable/uri'
require 'nokogiri'
require 'ruby-readability'
require 'statsd'

require 'models/content'
require 'extract_manager'
require 'extractor/media'
require 'extractor/readability'

require 'stats'

Stats.statsd = Statsd.new('localhost', 8152)
