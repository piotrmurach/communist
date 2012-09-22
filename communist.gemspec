# -*- encoding: utf-8 -*-
require File.expand_path('../lib/communist/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Piotr Murach"]
  gem.email         = [""]
  gem.description   = %q{Library for mocking CLI calls to external APIs}
  gem.summary       = %q{Library for mocking CLI calls to external APIs}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "communist"
  gem.require_paths = ["lib"]
  gem.version       = Communist::VERSION

  gem.add_dependency 'rack'
  gem.add_dependency 'json'
  gem.add_dependency 'sinatra'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
