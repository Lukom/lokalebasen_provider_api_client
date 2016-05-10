# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lokalebasen_api/version'

Gem::Specification.new do |gem|
  gem.name          = 'lokalebasen_api'
  gem.version       = LokalebasenApi::VERSION
  gem.authors       = ['Thomas Ringling', 'Mads Ohm Larsen']
  gem.email         = ['thomas.ringling@gmail.com', 'ml@lokalebasen.dk']
  gem.description   = 'Lokalebasen API client'
  gem.summary       = 'Ruby client for the Lokalebasen API'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'sawyer'
  gem.add_dependency 'map'

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
