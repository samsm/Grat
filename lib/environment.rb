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
    require lib_path + '/grat/mongomapper_patches'
    connection = if @@database_conf[:hostname]
      # auth = db.authenticate(my_user_name, my_password)
      Mongo::Connection.new(@@database_conf[:hostname])
    else
      Mongo::Connection.new
    end
    
    database = connection.db(@@database_conf[:database] || 'grat_development')
    
    if @@database_conf[:username] && @@database_conf[:password]
      database.authenticate(@@database_conf[:username], @@database_conf[:password])
    end
    
    MongoMapper.direct_database = database
    
    require Grat.lib_path + '/grat/content'
    require Grat.lib_path + '/grat/page'
    require Grat.lib_path + '/grat/template'
    
  end
end

require Grat.lib_path + '/grat/system'
