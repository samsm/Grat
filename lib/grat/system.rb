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
  
  not_found do
    missing_page
  end
  
  def url
    '/' + params[:splat].join('/')
  end
  
  def content
    @content ||= model.find_by_url(url) || model.new(:url => url)
  end
      
  def model
    return @model if @model
    
    # Sinatra reloads are slow when mongomapper has to re-require
    # This avoids requiring mongomapper when it isn't needed
    Grat.database_load
    
    @model = 
    case url.split('/')[1]
    when 'templates'
      Grat::Template
    else
      Grat::Page
    end
  end
  
  def focus_params
    params[:content].reject {|k,v| k == 'submit'}
  end
  
  def missing_page
    haml :missing
  end
      
end