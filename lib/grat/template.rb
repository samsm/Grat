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
  timestamps!
  
  def url=(val)
    super(val =~ BEGINS_WITH_TEMPLATE ? val : '/templates/' + val.sub(/\A\//,''))
  end
  
  def detect_variables_needed_by_content
    haml = Haml::Engine.new(content)
    variables_needed = {}
    # formats = [String,Array] # later
    render_fails = true
    counter = 0
    while render_fails
      counter += 1 
      return false if counter > 200 # no infinite loop, thanks
      begin
        content_with(variables_needed)
        render_fails = false
      rescue
        var = $!.to_s.sub(/.+`/,'').sub(/'.+/,'')
        variables_needed[var] = 'text'
      end
    end
    variables_needed.keys
  end
  
  def content_with(locals = {},y = '')
    haml = Haml::Engine.new(content)
    haml.render(haml,locals) { y }
  end
  
end