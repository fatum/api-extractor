require 'extractor/persist'
require 'extractor/media'
require 'extractor/readability'

class ResourceNotFound < Exception; end
class ExtractManager
  include Extractor::Persist

  def extractors
    @extractors ||= [
      Extractor::Media.new, Extractor::Readability.new
    ]
  end

  def perform(link, opts = {})
    response = EM::HttpRequest.new(link, opts).get redirects: opts[:redirects] || 3
    raise ResourceNotFound if response.response == ""

    extract_data_from(response) do |page_structure|
      check_and_update_content!(link, page_structure)
    end
  end

  def extract_data_from(response)
    data = {
      title: "",
      description: "",
      article: "",
      images: [],
      videos: [],
      url: response.last_effective_url.normalize.to_s
    }

    extractors.each do |extractor|
      extractor.analyze(data, response)
    end

    yield(data) if block_given?
    data
  end
end
