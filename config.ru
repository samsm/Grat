# config.ru
require 'rubygems'
require 'rack'
require 'lib/grat'
require 'ruby-debug'

Grat.database_conf # uses defaults
# to override:
# Grat.database_conf(:host => 'db.mongohq.com', :database => 'grat_production', :username => 'you', :password => 'whatever')

use Rack::ShowExceptions
run Grat::Application
