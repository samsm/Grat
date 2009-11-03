# Rakefile
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('grat', '0.0.5') do |p|
  p.summary        = "Minimal CMS for Rack and MongoDB."
  p.description    = "Basic interface for making webpages with Haml and Erb. Supports nested templates."
  p.url            = "http://samsm.com/"
  p.author         = "Sam Schenkman-Moore"
  p.email          = "samsm@samsm.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = ['sinatra','haml','sass','mongomapper']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
