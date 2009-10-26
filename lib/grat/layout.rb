class Grat::Layout
  include MongoMapper::Document
  include Grat::Content
  
  BEGINS_WITH_LAYOUT = /\A\/layout\/.+/
  
  key :url, String
  validates_uniqueness_of :url
  validates_format_of :url, :with => BEGINS_WITH_LAYOUT, :message => "needs to begin with '/layout'"
  
  key :content, String
  key :tags, Array
  
  def url=(val)
    super(val =~ BEGINS_WITH_LAYOUT ? val : '/layout/' + val.sub(/\A\//,''))
  end
  
end