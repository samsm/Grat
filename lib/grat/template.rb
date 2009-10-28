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
  
  before_save :detect_variables_needed_by_content
  
  def url=(val)
    super(val =~ BEGINS_WITH_TEMPLATE ? val : '/templates/' + val.sub(/\A\//,''))
  end
  
  def detect_variables_needed_by_content
    haml = Haml::Engine.new(content)
    demo_variables = {}
    # formats = [String,Array] # later
    render_fails = true
    counter = 0
    while render_fails
      counter += 1 
      return false if counter > 200 # no infinite loop, thanks
      begin
        content_with(demo_variables)
        render_fails = false
      rescue
        var = $!.to_s.sub(/.+`/,'').sub(/'.+/,'')
        demo_variables[var] = 'text'
      end
    end
    self.variables_needed = demo_variables.keys
  end
  
  def content_with(locals = {},y = '')
    haml = Haml::Engine.new(content)
    haml.render(haml,locals) { y }
  end
  
end