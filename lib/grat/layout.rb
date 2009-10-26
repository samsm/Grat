class Grat::Layout
  include MongoMapper::Document
  include Grat::Content
  
  BEGINS_WITH_LAYOUT = /\A\/layouts\/.+/
  
  key :url, String
  validates_uniqueness_of :url
  validates_format_of :url, :with => BEGINS_WITH_LAYOUT, :message => "needs to begin with '/layouts'"
  
  key :content, String
  key :tags, Array
  
  def url=(val)
    super(val =~ BEGINS_WITH_LAYOUT ? val : '/layouts/' + val.sub(/\A\//,''))
  end
  
end