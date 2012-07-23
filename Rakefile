#!/usr/bin/env rake
#require 'rspec/core/rake_task'
require 'sequel'

require './lib/configuration'

Sequel.extension :migration

#RSpec::Core::RakeTask.new(:spec)
#task :default => :spec

environment = ENV["ENV"] || "development"
DB = Sequel.connect(Configuration.database[environment])

namespace :db do
  desc "Migrate database version"
  task :migrate, [:version] do |t, args|
    Sequel::Migrator.apply(DB, 'db/migrations')
  end

  desc "Rollback migration"
  task :rollback, [:step] do |t, args|
    version = (row = DB[:schema_info].first) ? row[:version] - 1 : 0

    Sequel::Migrator.apply(DB, 'db/migrations', version)
  end
end

