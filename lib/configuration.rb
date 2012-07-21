require 'yaml'

class Configuration
  def self.database
    @@database ||= YAML.load_file(File.join(File.dirname(__FILE__), "../config/database.yml"))
  end
end

