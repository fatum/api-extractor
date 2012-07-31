# -*- encoding : utf-8 -*-

require 'deploy/helper'

set :application, "extractor"
set :stages, ['production', 'staging']
set :default_stage, 'staging'

set :scm, :git
set :scm_verbose, true

set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
set :deploy_to, "/srv/projects/#{application}"

set :use_sudo, false
set :user, "vagrant"
set :run_user, "service"

set :branch, "master"
set :repository, "git@github.com:fatum/extractor-goliath.git"

# Roundsman
set :roundsman_user, user
set :apache, listen_ports: [8080]

# TODO: Check .rbenv-version
set :ruby_version, '1.9.3-p125'

before "deploy:setup", "roundsman:install"
before "deploy:setup", "roundsman:chef:install"
before "deploy:setup", "deploy:bundler_install"

after "deploy:update", "deploy:setup_upstart_scripts"
after "deploy:migrations", "deploy:setup_upstart_scripts"
after "deploy", "deploy:setup_upstart_scripts"

namespace :deploy do
  task :server_setup do
    fetch_cookbooks
    nginx_install
    mysql_install
  end

  task :fetch_cookbooks do
    run "cd #{current_release} && git submodule update"
  end

  task :migrate do
    run "cd #{current_release} && bundle exec rake db:migrate"
  end

  task :nginx_install, role: :app do
    roundsman.run_list "recipe[runit]",
                       "recipe[nginx]"
  end

  task :mysql_install, role: :db do
    roundsman.run_list "recipe[mysql::server]"
  end

  task :munin_install do
    apache2_install
    roundsman.run_list "recipe[munin::server]"
  end

  task :apache2_install do
    roundsman.run_list "recipe[apache2]"
  end

  task :bundler_install, role: :app do
    %w(bundle).each do |gem|
      sudo "gem install #{gem} --quiet --no-ri --no-rdoc"
    end
  end

  desc "[Re]generate upstart scripts from Procfile and [re]start services"
  task :setup_upstart_scripts, :roles => [:app] do
    do_upstart_action(:stop, "extractor")
    run <<-CMD
      cd #{current_release} && bundle exec foreman export upstart /etc/init -u #{user} -f #{current_release}/config/upstart/Procfile.#{stage}
    CMD
    do_upstart_action(:start, "extractor")
  end
end
