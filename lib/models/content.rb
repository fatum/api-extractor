class Content < Sequel::Model
  plugin :serialization, :yaml, :content

  def self.find_by_url(url)
    find(hash_url: hash(url))
  end

  def self.hash(url)
    Digest::MD5.hexdigest(url)
  end
end
