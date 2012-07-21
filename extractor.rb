require 'pathname'
$LOAD_PATH.unshift(Pathname(File.join(File.dirname(__FILE__), './lib/')).realpath)

require 'goliath'

require 'sequel'
require 'em-synchrony'
require 'em-synchrony/em-http'

class Extractor < Goliath::API
  use Goliath::Rack::Params
  use Goliath::Rack::Validation::RequestMethod, %w(GET)

  def response(env)
    unless env["PATH_INFO"] == '/api/v1/extractor'
      return [404, {}, "Not found"]
    end

    [200, {}, {:response => "ok"}]
  end
end

#class SimpleAPI < Goliath::API
#  def response(env)
#    req = EM::HttpRequest.new("http://www.google.com/").get
#    resp = req.response

#    [200, {}, "Request handled: #{resp}"]
#  end
#end
