require File.dirname(__FILE__) + '/environment.rb'

module Grat
  class Application < Sinatra::Base
    get '/favicon.ico' do
      pass
    end
    
    get '/css/:name.css' do
      sass "css/_#{params[:name]}".to_sym
    end
    
    get '/admin/__all' do
      @pages = Page.all
      @templates = Template.all
      haml :list
    end
    
    get '/admin/*' do
      haml :content_form
    end
    
    post '/admin/*' do
      content.update_attributes(focus_params)
      redirect "/admin#{content.url}"
    end
    
    get '/*' do
      pass if content.new_record?
      template_chain.inject('') do |sum, template|
        locals ||= {}
        locals.merge!(template.attributes)
        haml_template = Haml::Engine.new(template.content)
        haml_template.render(haml_template, locals) { sum }
      end
    end
    
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
        Template
      else
        Page
      end
    end
    
    def focus_params
      params[:content].reject {|k,v| k == 'submit'}
    end
    
    def missing_page
      haml :missing
    end
    
    helpers do
      def form_nest(name)
        "content[#{name}]"
      end
      def stylesheet_tag(href)
        "<link rel=\"stylesheet\" type=\"text/css\" media=\"all\"  href=\"http://grat.local/css/#{href}\" />"
      end
    end
    
  end
end