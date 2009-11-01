class Grat::Template
  include MongoMapper::Document
  include Grat::Content
  
  BEGINS_WITH_TEMPLATE = /\A\/templates\/.+/
  
  key :url, String
  validates_uniqueness_of :url
  validates_format_of :url, :with => BEGINS_WITH_TEMPLATE, :message => "needs to begin with '/templates'"
  
  key :content, String
  key :tags, Array
  key :template_url, String
  key :variables_needed, Array
  timestamps!
  
  # Turn this off for a second
  # before_save :detect_variables_needed_by_content
  
  def url=(val)
    super(val =~ BEGINS_WITH_TEMPLATE ? val : '/templates/' + val.sub(/\A\//,''))
  end
    
end