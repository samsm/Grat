class Grat::Template
  include MongoMapper::Document
  include Grat::Content
  
  BEGINS_WITH_TEMPLATE = /\A\/templates\/.+/
  
  key :url, String
  validates_uniqueness_of :url
  validates_format_of :url, :with => BEGINS_WITH_TEMPLATE, :message => "needs to begin with '/templates'"
  
  key :content, String
  key :tags, Array
  timestamps!
  
  def url=(val)
    super(val =~ BEGINS_WITH_TEMPLATE ? val : '/templates/' + val.sub(/\A\//,''))
  end
  
end