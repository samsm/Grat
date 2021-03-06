require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "grat"
    gem.summary = "Minimal CMS for Rack and MongoDB."
    gem.description = "Basic interface for making webpages with Haml and Erb. Supports nested templates."
    gem.email = "samsm@samsm.com"
    gem.homepage = "http://github.com/samsm/grat"
    gem.authors = ["Sam Schenkman-Moore"]
    gem.add_development_dependency "yard", ">= 0"
    gem.add_runtime_dependency 'sinatra'
    gem.add_runtime_dependency 'haml'
    gem.add_runtime_dependency 'mongo_mapper', "0.8.0"

    gem.add_runtime_dependency 'json'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
