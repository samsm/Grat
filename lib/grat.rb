require File.dirname(__FILE__) + '/environment.rb'

class Grat::Application < Sinatra::Base
  
  include Grat::System
    
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
  
  get '/gratfiles/:filename' do
    file_data = IO.read(Grat.root_path + '/public/gratfiles/' + params[:filename])
    case params[:filename]
    when /\.css\Z/
      content_type('text/css')
    when /\.js\Z/
      content_type('text/javascript')
    end
    file_data
  end
  
  helpers do
    def form_nest(name)
      "content[#{name}]"
    end
  end
  
end