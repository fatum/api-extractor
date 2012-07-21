# -*- encoding : utf-8 -*-

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
role :db, "#{user}@localhost:2222", primary: true

before "deploy:setup", "roundsman:install"
before "deploy:setup", "roundsman:chef:install"
before "deploy:setup", "deploy:bundler_install"

namespace :deploy do
  task :server_setup, [:fetch_cookboks, :nginx_install, :mysql_install] do
  end

  task :fetch_cookboks do
    run "git submodule update"
  end

  task :nginx_install, role: :app do
    roundsman.run_list "recipe[runit]",
                       "recipe[nginx]"
  end

  task :mysql_install, role: :db do
    roundsman.run_list "recipe[mysql::server]"
  end

  task :bundler_install, role: :app do
    %w(bundle).each do |gem|
      sudo "gem install #{gem} --quiet --no-ri --no-rdoc"
    end
  end
end
