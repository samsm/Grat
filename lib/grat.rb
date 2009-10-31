require File.dirname(__FILE__) + '/environment.rb'

class Grat::Application < Sinatra::Base
  
  include Grat::System
  
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
  
  helpers do
    def form_nest(name)
      "content[#{name}]"
    end
    def stylesheet_tag(href)
      "<link rel=\"stylesheet\" type=\"text/css\" media=\"all\"  href=\"http://grat.local/css/#{href}\" />"
    end
  end
  
end