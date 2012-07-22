module Worker
  class Readability
    extend Worker::Base

    def self.perform(link)
      req = EM::HttpRequest.new(link).get

      content = Extractor::Readability.extract(link, req)
      check_and_update_content!(link, content)
      content
    end
  end
end
