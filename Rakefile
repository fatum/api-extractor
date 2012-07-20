#!/usr/bin/env rake
require 'rspec/core/rake_task'
require 'sequel'

Sequel.extension :migration

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  desc "Migrate database version"
  task :migrate, [:version] do |t, args|
    Sequel::Migrator.run(DB, 'db/migrations', :use_transactions=>false)
  end
end

