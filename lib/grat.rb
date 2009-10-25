require 'ruby-debug'
require 'sinatra'
require 'haml'
require 'sass'
require 'mongomapper'
MongoMapper.database = 'grat_development'

require File.dirname(__FILE__) + '/grat/content'


module Grat
  class Application < Sinatra::Base
    get '/favicon.ico' do
      nil
    end
    
    get '/:name.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass "css/_#{params[:name]}".to_sym
    end
    
    get '/admin/*' do
      haml :content_form
    end
    
    post '/admin/*' do
      content.update_attributes(focus_params)
      redirect "/admin#{content.url}"
    end
    
    get '/*' do
      haml(content.content) #or missing_page
    end
    
    def url
      '/' + params[:splat].join('/')
    end
    
    def content
      @content ||= Content.find_by_url(url) || Content.new(:url => url)
    end
    
    def focus ; 'content' ; end
    
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
        "<link rel=\"stylesheet\" type=\"text/css\" media=\"all\"  href=\"/#{href}\" />"
      end
    end
    
  end
end