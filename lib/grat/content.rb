class Grat::Content
  include MongoMapper::Document
  attr_accessor :suggested_fields

  key :url
  validates_uniqueness_of :url
  key :content
  key :tags, Array
  key :template_url

  before_save :detect_default_content_vars
  key :default_content_vars, Hash

  def attributes_for_variables
    attributes.reject {|k,v| k == '_id' }
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

  def tags
    super or []
  end

  def self.find_all_by_tag(tag_name)
    all(:conditions => {'tags' => [tag_name]})
  end

  def type
    self.class.to_s.sub(/.+::/, '')
  end

  def default_content_vars
    super or {}
  end

  def default_content_vars=(val)
    super val.kind_of?(String) ? JSON.parse(val) : val
  end

  def template
    @template ||= Grat::Content.find_by_url(template_url) if template_url
  end

  def template=(var)
    raise 'This is probably a mistake.'
  end

  def template_url=(var)
    super(var) unless var.nil? || var.empty?
  end

  def demo_string
    'String needed'
  end

  def demo_array
    %w(an array is needed)
  end

  def render_engine
    if content.match(/\A[!%#.=-]/)
      :haml
    else
      :erb
    end
  end

  def detect_default_content_vars
    counter = 0
    while problem_var = detect_problem_var
      counter += 1
      return false if counter > 200
      (detect_problem_var(problem_var => demo_string) ||
        default_content_vars.merge!(problem_var => demo_string)) or
      (detect_problem_var(problem_var => demo_array) ||
        default_content_vars.merge!(problem_var => demo_array)) or
      raise "Don't know how to reconcile."
    end
  end

  def haml_render(text, template, vars)
    require 'haml'
    haml_template = Haml::Engine.new(template)
    haml_template.render(haml_template, vars) { text }
  end

  def erb_render(text, template, vars)
    require 'erb'
    ERB.new(template,0).result(Grat::HashBinding.new(vars).get_binding { text })
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
    send "#{render_engine}_render", y, content, locals
  end

  def suggested_fields
    @suggested_fields or []
  end

  def children
    @children ||= []
  end

end

class Grat::EmptyContent
  attr_accessor :url
  def initialize(url)
    self.url = url
  end

  def children
    @children ||= []
  end

end
