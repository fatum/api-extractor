namespace :extractor do
  desc "Extract page's content using readability"
  task :readability, [:url] => :environment do |t, args|
    puts Extractor::Readability.extract(args[:url] || 'http://dirty.ru')
  end
end
