require 'mongomapper'

module MongoMapper
  
  # This allows for passwords, amongst other things.
  def self.direct_database=(mongo_db_connection)
    @@database_name = mongo_db_connection.name
    @@database = mongo_db_connection
  end
  
end