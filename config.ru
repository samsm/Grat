# config.ru
require 'rubygems'
require 'rack'
require 'lib/grat'

use Rack::ShowExceptions
run Grat::Application
