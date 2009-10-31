require 'ruby-debug'
require 'sinatra'
require 'haml'
require 'sass'
require 'mongomapper'
MongoMapper.database = 'grat_development'

module Grat ; end

require File.dirname(__FILE__) + '/grat/content'
require File.dirname(__FILE__) + '/grat/page'
require File.dirname(__FILE__) + '/grat/template'
require File.dirname(__FILE__) + '/grat/system'
