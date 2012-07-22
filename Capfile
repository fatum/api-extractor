require 'pathname'
$LOAD_PATH.unshift(Pathname(File.join(File.dirname(__FILE__), './lib/')).realpath)

load 'deploy'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

require 'roundsman/capistrano'
require 'capistrano/ext/multistage'
require 'bundler/capistrano'

load 'config/deploy' # remove this line to skip loading any of the default tasks
