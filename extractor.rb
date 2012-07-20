$: << './'

require 'sinatra'
require 'sinatra/synchrony'
require 'sinatra/sequel'

require 'environment'
require 'db/migrations'

require 'models/content'

require 'logger'
database.loggers << Logger.new(STDOUT)

get '/' do
  Content.count
  Content.all
  'Sinatra::Synchrony is loaded automatically in classic mode, nothing needed'
end
