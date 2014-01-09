require 'rubygems'
require 'chef'
require 'yard'

YARD::Config.load_plugin 'chef'
YARD::Rake::YardocTask.new do |t|
  t.files = ['./**/*.rb']
  #t.options = ['--debug']
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
