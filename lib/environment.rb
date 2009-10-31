require 'ruby-debug'
require 'sinatra'
require 'haml'
require 'sass'
require 'mongomapper'
MongoMapper.database = 'grat_development'

module Grat
  
  def self.database_conf(options = {})
    if options[:hostname]
      MongoMapper.connection = XGen::Mongo::Driver::Mongo.new(options[:hostname])
    end
    
    MongoMapper.database = options[:database] || 'grat_development'
    
  end
end

require File.dirname(__FILE__) + '/grat/content'
require File.dirname(__FILE__) + '/grat/page'
require File.dirname(__FILE__) + '/grat/template'
require File.dirname(__FILE__) + '/grat/system'
