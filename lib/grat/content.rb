require 'haml'
module Grat::Content
  
  def editable_fields
    attributes.reject {|k,v| uneditable_keys.include? k }
  end
  
  def uneditable_keys
    # url is in here so it can maually be placed at the top of edit form.
    ["updated_at", "_id", "url", "created_at","content","tags",'template_url','template']
  end
  def tags=(val)
    super(val.kind_of?(Array) ? val : val.split(' '))
  end
  
  def type
    self.class.to_s.sub(/.+::/, '')
  end
  
  def template
    @template ||= Grat::Template.find_by_url(template_url) if template_url
  end
  
  def template_url=(var)
    super(var) unless var.empty?
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