class Extractor
  module Persist
    def check_and_update_content!(link, content)
      raise "Unexpected url" unless link

      Content.create(
        hash_url: Content.hash(link),
        content: Content.serialize(content)
      ) if content_valid?(content)
    end

    def content_valid?(content)
      !(content[:article] == nil && content.keys == [:article])
    end
  end
end
