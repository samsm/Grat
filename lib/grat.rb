require 'ruby-debug'
require 'sinatra'
require 'haml'
require 'sass'
require 'mongomapper'
MongoMapper.database = 'grat_development'

module Grat ; end

require File.dirname(__FILE__) + '/grat/content'
require File.dirname(__FILE__) + '/grat/page'
require File.dirname(__FILE__) + '/grat/layout'


module Grat
  class Application < Sinatra::Base
    get '/favicon.ico' do
      nil
    end
    
    get '/css/:name.css' do
      sass "css/_#{params[:name]}".to_sym
    end
    
    get '/admin/:focus/*' do
      haml :content_form
    end
    
    post '/admin/:focus/*' do
      content.update_attributes(focus_params)
      redirect "/admin/#{focus}#{content.url}"
    end
    
    get '/*' do
      pass if content.new_record?
      if content.layout
        haml(content.content, :layout => Layout.find_by_url(content.layout).content)
      else
        haml content.content
      end
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
    
    def focus
      params[:focus] or 'page'
    end
    
    def model ; Grat.const_get focus.capitalize ; end
    
    def focus_params
      params[focus].reject {|k,v| k == 'submit'}
    end
    
    def missing_page
      haml :missing
    end
    
    
    
    helpers do
      def form_nest(name,context = focus)
        "#{context}[#{name}]"
      end
      def stylesheet_tag(href)
        "<link rel=\"stylesheet\" type=\"text/css\" media=\"all\"  href=\"http://grat.local/css/#{href}\" />"
      end
    end
    
  end
end