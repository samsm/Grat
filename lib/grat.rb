require 'sinatra'

module Grat
  class Application < Sinatra::Base
    get '/' do
      'hi'
    end
    
  end
end