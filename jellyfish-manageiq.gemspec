$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'jellyfish/manageiq/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jellyfish-manageiq'
  s.version     = Jellyfish::ManageIQ::VERSION
  s.authors     = ['Jerimiah Milton']
  s.email       = ['milton_jerimiah@bah.com']
  s.homepage    = 'http://www.projectjellyfish.org/'
  s.summary     = 'Jellyfish Manage IQ gem'
  s.description = 'A Manage IQ gem for Project Jellyfish'
  s.license     = 'APACHE'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']

  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'rails'
  s.add_runtime_dependency 'pundit'
  s.add_runtime_dependency 'rufus-scheduler'
  s.add_runtime_dependency 'virtus'
  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'jellyfish-provisioner'
  s.add_runtime_dependency 'apipie-rails', '~> 0.2.6'

  s.add_development_dependency 'puma'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'pg', '~> 0.17.1'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
end
