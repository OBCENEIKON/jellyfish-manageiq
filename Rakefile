begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rails/all'
require 'rake'
require 'rdoc/task'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'jellyfish/manageiq'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Jellyfish::ManageIQ'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Dir[File.join(File.dirname(__FILE__), 'lib/tasks/*.rake')].each { |rake_file| load rake_file }

task default: :spec

Bundler::GemHelper.install_tasks
