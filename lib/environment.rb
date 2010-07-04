require 'sinatra'
require 'json'

module Grat
  @@connection = nil
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
    require 'mongo_mapper'
    if @@database_conf[:host]
      MongoMapper.connection = Mongo::Connection.new(@@database_conf[:host])
    end

    MongoMapper.database = @@database_conf[:database] || 'grat_development'

    if @@database_conf[:username] && @@database_conf[:password]
      MongoMapper.database.authenticate(@@database_conf[:username], @@database_conf[:password])
    end

    require Grat.lib_path + '/grat/content'
    require Grat.lib_path + '/grat/hwia_patch'

  end

  def self.database
    MongoMapper.database
  end
end

require Grat.lib_path + '/grat/system'
require Grat.lib_path + '/grat/hash_binding'