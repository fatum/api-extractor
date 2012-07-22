class Content < Sequel::Model
  def self.find_by_url(url)
    find(hash_url: hash(url))
  end

  def self.hash(url)
    Digest::MD5.hexdigest(url)
  end

  def self.serialize(content)
    content.to_yaml
  end

  def self.deserealize(string)
    YAML.load(string)
  end
end
