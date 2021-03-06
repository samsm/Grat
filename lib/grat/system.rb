module Grat::System
  def template_chain
    current = content
    collection = [content]
    while current.template
      current = current.template
      collection << current
    end
    collection
  end
  
  def request_type
    case env['HTTP_ACCEPT']
    when /html/
      'html'
    when /json/
      'json'
    when /xml/ #?
      'xml'
    end
  end
  
  not_found do
    missing_page
  end
  
  def url
    '/' + params[:splat].join('/')
  end
  
  def content
    @content ||= model.find_by_url(url) || new_content
  end
  
  def new_content
    content = model.new(:url => url)
    if params[:template]
      template = model.find_by_url params[:template]
      if template
        content.template_url = template.url
        content.suggested_fields = template.default_content_vars.keys
      end
    end
    content
  end
      
  def model
    return @model if @model
    
    # Sinatra reloads are slow when mongoid has to re-require
    # This avoids requiring mongoid when it isn't needed
    Grat.database_load
    
    @model = Grat::Content
  end
  
  def focus_params
    params[:content].reject {|k,v| k == 'submit'}
  end
  
  def missing_page
    haml :missing
  end
      
end