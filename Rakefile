# Rakefile
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('grat', '0.0.2') do |p|
  p.description    = "Minimal CMS for Rack and MongoDB."
  p.url            = "http://samsm.com/"
  p.author         = "Sam Schenkman-Moore"
  p.email          = "samsm@samsm.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = ['ruby-debug','sinarta','haml','sass','mongomapper']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
