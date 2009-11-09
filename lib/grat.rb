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
  
  get '/admin/__export' do
    content_type('text/json')
    # Content-disposition: attachment; filename=fname.ext
    response['Content-disposition'] = "attachment; filename=grat-export-at-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.json"
    model.all.to_json
  end
  
  get '/admin/__import' do
    haml :import_form
  end
  
  post '/admin/__import' do
    json_text = file_import_text || params[:import][:text]
    @import_results = import(json_text, params[:import][:strategy])
    redirect '/admin/__all'
  end
  
  # Rather inefficient at present.
  def import(json_text, strategy)
    json_to_import = JSON.parse json_text
    if json_to_import.is_a? Array
      model.delete_all if strategy == 'demolish'
      json_to_import.each do |record|
        case strategy
        when 'add'
          import_record record
        when 'replace'
          import_record record, {:replace => true, :check=> true}
        when 'demolish'
          import_record record, {:replace => true, :check => false}
        end
      end
    end
  end
  
  def import_record(hash, options = {:replace => false, :check => true})
    record = model.find_by_url(hash['url']) if options[:check]
    if record && options[:replace]
      record.destroy if record
    end
    unless record && !options[:replace]
      model.create hash
    end
  end
  
  def file_import_text
    if params[:import] && params[:import][:file] && params[:import][:file][:tempfile]
      params[:import][:file][:tempfile].read
    end
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
      locals = template.default_content_vars.
                 merge(template.attributes_for_variables).
                 merge(locals)
      combine_docs(sum,template, locals)
    end
  end
  
  def combine_docs(text,template,vars)
    template.content_with(vars,text)
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