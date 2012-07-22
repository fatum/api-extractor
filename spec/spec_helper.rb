require File.join(File.dirname(__FILE__), '..', 'extractor.rb')

require 'goliath/test_helper'
require 'json'

RSpec.configure do |c|
  c.include Goliath::TestHelper, :example_group => {
    :file_path => /spec/
  }
end
