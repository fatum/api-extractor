module Worker
  module Base
    def check_and_update_content!(link, content)
      raise "Unexpected url" unless link

      Content.create(
        hash_url: Content.hash(link),
        content: Content.serialize(content)
      )
    end
  end
end
