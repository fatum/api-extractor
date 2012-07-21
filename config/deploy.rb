# -*- encoding : utf-8 -*-
Capistrano::Configuration::Namespaces::Namespace.class_eval do
  def capture(*args)
    parent.capture *args
  end
end

set :application, "extractor"
set :stages, ['production', 'staging']
set :default_stage, 'staging'

set :scm, :git
set :scm_verbose, true

set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
set :deploy_to, "/srv/projects/#{application}"
set :ssh_options, {:forward_agent => true, :keys => %w{~/.vagrant.d/insecure_private_key}}

set :use_sudo, false
set :user, "vagrant"
set :run_user, "service"

set :branch, "master"
set :repository, "https://github.com/fatum/state-handler.git"

# Roundsman
set :roundsman_user, user
# TODO: Check .rbenv-version
set :ruby_version, '1.9.3-p125'

role :app, "#{user}@localhost:2222", primary: true

before "deploy:setup", "roundsman:install"
before "deploy:setup", "roundsman:chef:install"
before "deploy:setup", "deploy:bundler_install"

namespace :deploy do
  task :bundler_install, role: :app do
    sudo "gem install bundle"
  end
end
