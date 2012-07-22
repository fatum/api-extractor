module Worker
  class Boilerpipe
    include Worker::Base

    @queue = :extractor_boilerpipe_queue

    def self.perform(url)
      content = Extractor::Boilerpipe.extract(url)
      url = Url.find_by_hash_url(Url.hash(url))

      check_and_update_content!(url, content)
    end
  end
end
