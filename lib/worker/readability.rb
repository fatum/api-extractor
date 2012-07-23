module Worker
  class Readability
    extend Worker::Base

    def self.perform(link, opts = {})
      req = EM::HttpRequest.new(link, opts).get

      content = Extractor::Readability.extract(link, req)
      check_and_update_content!(link, content)
      content
    end
  end
end
