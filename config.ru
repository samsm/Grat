# config.ru
require 'rubygems'
require 'rack'
require 'lib/grat'

Grat.database_conf # uses defaults
# to override:
# Grat.database_conf(:host => 'localhost', :database => 'grat_delete')

use Rack::ShowExceptions

run Grat::Application
