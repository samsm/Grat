class Grat::Page
  include MongoMapper::Document
  include Grat::Content
  
  key :url, String
  key :tags, Array
  key :content, String
  key :layout, String
  
  validates_uniqueness_of :url
  timestamps!
    
end