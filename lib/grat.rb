require File.dirname(__FILE__) + '/environment.rb'

class Grat::Application < Sinatra::Base
  
  include Grat::System
  
  set :views, Grat.view_path
  set :methodoverride, true
  
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
  
  get '/__admin/all' do
    @pages = model.all
    @templates = templates
    haml :list
  end
  
  get '/__admin/export' do
    content_type('text/json')
    # Content-disposition: attachment; filename=fname.ext
    response['Content-disposition'] = "attachment; filename=grat-#{request.host}-export-at-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.json"
    model.all.to_json
  end
  
  get '/__admin/import' do
    haml :import_form
  end
  
  post '/__admin/import' do
    json_text = file_import_text || params[:import][:text]
    @import_results = import(json_text, params[:import][:strategy])
    redirect '/__admin/all'
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
  
  get '/__admin/edit/*' do
    haml :content_form
  end
  
  get '/__admin/delete/*' do
    haml :delete
  end
  
  put '/*' do
    content.update_attributes(focus_params)
    redirect edit_path(content.url)
  end
  
  delete '/*' do
    content.destroy
    redirect edit_path(content.url)
  end
  
  post '/*' do
    content.update_attributes(focus_params)
    if params[:content][:submit].include? 'make'
      redirect edit_path(next_content_url)
    else
      redirect edit_path(content.url)
    end
  end
  
  def next_content_url
    url = content.url
    number      = url[/\d*\Z/]
    next_number = number.to_i + 1
    url.sub!(/\d*\Z/, next_number.to_s)
    if content.template_url
      url + '?template=' + content.template_url
    else
      url
    end
  end
  
  get '/*' do
    pass if content.new_record?
    
    case request_type
    when 'html'
      locals = {}
      template_chain.inject('') do |sum, template|
        locals = template.default_content_vars.
                   merge(template.attributes_for_variables).
                   merge(locals)
        combine_docs(sum,template, locals)
      end
    when 'json'
      response['Content-Type'] = 'application/json'
      content.to_json
    end
  end
  
  not_found do
    haml :missing
  end
  
  def edit_path(url)
    "/__admin/edit#{url}"
  end
  
  def delete_path(url)
    "/__admin/delete#{url}"
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