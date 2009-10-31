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
    @model ||= 
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