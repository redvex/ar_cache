require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('ar_cache', '0.1.0') do |p|
  p.description    = "Performe ActiveRecord cache in File System for heavy and repetitive query."
  p.url            = "http://github.com/redvex/ar_cache"
  p.author         = "Gianni Mazza"
  p.email          = "redvex@me.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.runtime_dependencies = ['json']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
