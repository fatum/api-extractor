if RUBY_PLATFORM.include?("java")
  require "#{Rails.root}/java/boilerpipe-1.2.0.jar"
  require "#{Rails.root}/java/boilerpipe-sources-1.2.0.jar"
  require "#{Rails.root}/java/lib/nekohtml-1.9.13.jar"
  require "#{Rails.root}/java/lib/xerces-2.9.1.jar"

  include_class "de.l3s.boilerpipe.extractors.ArticleExtractor"
  include_class "de.l3s.boilerpipe.extractors.DefaultExtractor"
  include_class "de.l3s.boilerpipe.extractors.CanolaExtractor"
  include_class "de.l3s.boilerpipe.extractors.LargestContentExtractor"
end

class Extractor::Boilerpipe

  def self.extract(url)
    content = Extractor::Media.extract(url) || {}
    content[:article] = extract_text(url)
    content
  end

private
  def self.extract_text(url)
    url = java.net.URL.new(url)
    clear(extractor(:article).getText(url))
  end

  def self.clear(text)
    text
  end

  def self.extractor(name = nil)
    case name
    when :article
      Java::DeL3sBoilerpipeExtractors::ArticleExtractor.new
    when :canola
      Java::DeL3sBoilerpipeExtractors::CanolaExtractor.new
    when :largest_content
      Java::DeL3sBoilerpipeExtractors::LargestContentExtractor.new
    else
      Java::DeL3sBoilerpipeExtractors::DefaultExtractor.new
    end
  end
end
