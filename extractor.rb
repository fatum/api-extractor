require 'pathname'
$LOAD_PATH.unshift(Pathname(File.join(File.dirname(__FILE__), './lib/')).realpath)

require 'goliath'
require 'sequel'
require 'em-synchrony/em-http'

class Extractor < Goliath::API
  use Goliath::Rack::Params
  use Goliath::Rack::DefaultMimeType
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Render
  use Goliath::Rack::Validation::RequestMethod, %w(GET)

  def response(env)
    unless env["PATH_INFO"] == '/api/v1/extractor'
      return [404, {}, "Not found"]
    end

    response = if row = Content.find_by_url(params["url"])
      Content.deserealize(row.content)
    else
      ExtractManager.new.perform(params["url"], env.config[:http])
    end

    [200, {"Content-Type" => "application/json"}, response: response]
  end
end
