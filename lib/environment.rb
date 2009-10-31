require 'ruby-debug'
require 'sinatra'
require 'haml'
require 'sass'
require 'mongomapper'
MongoMapper.database = 'grat_development'

module Grat
  
  def self.root_path
    File.dirname(File.dirname(__FILE__))
  end
  
  def self.lib_path
    root_path + '/lib'
  end
  
  def self.database_conf(options = {})
    if options[:hostname]
      MongoMapper.connection = XGen::Mongo::Driver::Mongo.new(options[:hostname])
    end
    
    MongoMapper.database = options[:database] || 'grat_development'
    
  end
end

require Grat.lib_path + '/grat/content'
require Grat.lib_path + '/grat/page'
require Grat.lib_path + '/grat/template'
require Grat.lib_path + '/grat/system'
