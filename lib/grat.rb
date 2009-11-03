require File.dirname(__FILE__) + '/environment.rb'

class Grat::Application < Sinatra::Base
  
  include Grat::System
  
  set :views, Grat.view_path
  
  # serve some static assets directly from gem
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
  
  get '/admin/__all' do
    @pages = model.all
    @templates = templates
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
    locals = {}
    template_chain.inject('') do |sum, template|
      locals.merge!(template.default_content_vars.merge(template.attributes))
      
      combine_docs(sum,template, locals)
      # require 'haml'
      # haml_template = Haml::Engine.new(template.content)
      # result = haml_template.render(haml_template, locals) { sum }
    end
  end
  
  def combine_docs(text,template,vars)
    send "#{detect_template_type(template)}_render", text, template, vars
  end
  
  def haml_render(text, template, vars)
    require 'haml'
    haml_template = Haml::Engine.new(template.content)
    haml_template.render(haml_template, vars) { text }
  end
  
  def erb_render(text, template, vars)
    require 'erb'
    ERB.new(template.content,0).result(Grat::HashBinding.new(vars).get_binding { text })
  end
  
  def detect_template_type(template)
    if template.content.match(/\A[!%#.=-]/)
      'haml'
    else
      'erb'
    end
  end
  
  def haml(*args)
    require 'haml'
    super(*args)
  end
  
  def templates
    model.find_all_by_tag('template')
  end
    
  helpers do
    def form_nest(name)
      "content[#{name}]"
    end
  end
  
end