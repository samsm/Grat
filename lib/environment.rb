require 'sinatra'

module Grat
  @@database_conf = {}
  def self.root_path
    File.dirname(File.dirname(__FILE__))
  end
  
  def self.lib_path
    root_path + '/lib'
  end
  
  def self.view_path
    root_path + '/views'
  end
  
  def self.database_conf(options = {})
    @@database_conf = options    
  end
  
  def self.database_load
    require 'mongomapper'
    if @@database_conf[:hostname]
      MongoMapper.connection = XGen::Mongo::Driver::Mongo.new(@@database_conf[:hostname])
    end
    
    MongoMapper.database = @@database_conf[:database] || 'grat_development'
    
    require Grat.lib_path + '/grat/content'
    require Grat.lib_path + '/grat/page'
    require Grat.lib_path + '/grat/template'
    
  end
end

require Grat.lib_path + '/grat/system'
