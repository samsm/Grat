module Grat::Content
  
  def self.included(base)
    base.key :url, String
    base.validates_uniqueness_of :url
    base.key :content, String
    base.key :tags, Array
    base.key :template_url, String
    base.key :variables_needed, Array
    base.timestamps!
    
    base.before_save :detect_default_content_vars
    base.key :default_content_vars, Hash
    
    base.key :render_engine_name, String
  end
  
  def editable_fields
    attributes.reject {|k,v| uneditable_keys.include? k }
  end
  
  def uneditable_keys
    # url is in here so it can maually be placed at the top of edit form.
    # Same deal with template_url
    ["updated_at", "_id", "url", "created_at","content","tags",'template_url','template',
      'default_content_vars','variables_needed','render_engine_name']
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
  
  def template=(var)
    raise 'This is probably a mistake.'
  end
  
  def template_url=(var)
    super(var) unless var.empty?
  end
  
  def demo_string
    'String needed'
  end
  
  def demo_array
    %w(an array is needed)
  end
  
  def render_engine
    @render_engine ||= case render_engine_name
    when 'haml',nil # the default for now
      require 'haml'
      Haml::Engine.new(content)
    when 'erb'
      raise 'Unimplemented!'
    end
  end
  
  # def detect_variables_needed_by_content
  #   demo_variables = {}
  #   # formats = [String,Array] # later
  #   render_fails = true
  #   counter = 0
  #   while render_fails
  #     counter += 1 
  #     return false if counter > 200 # no infinite loop, thanks
  #     begin
  #       content_with(demo_variables)
  #       render_fails = false
  #     rescue
  #       var = $!.to_s.sub(/.+`/,'').sub(/'.+/,'')
  #       demo_variables[var] = 'text'
  #     end
  #   end
  #   self.variables_needed = demo_variables.keys
  # end
  
  def detect_default_content_vars
    counter = 0
    while problem_var = detect_problem_var
      counter += 1
      return false if counter > 200
      (detect_problem_var(problem_var => demo_string) || 
        default_content_vars.merge!(problem_var => demo_string)) or
      (detect_problem_var(problem_var => demo_array) || 
        default_content_vars.merge!(problem_var => demo_string)) or
      raise "Don't know how to reconcile."
    end
  end
  
  def detect_problem_var(resolution = {})
    begin
      rendered = content_with(default_content_vars.merge(resolution), problem_var = nil)
      return false
    rescue
      $!.to_s.sub(/.+`/,'').sub(/'.+/,'')
    end
  end
  
  def content_with(locals = {},y = '')
    render_engine.render(render_engine,locals) { y }
  end
  
  
end