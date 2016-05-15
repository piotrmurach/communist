# -*- encoding: utf-8 -*-
require File.expand_path('../lib/communist/version', __FILE__)

Gem::Specification.new do |spec|
  spec.authors       = ["Piotr Murach"]
  spec.email         = [""]
  spec.description   = %q{Library for mocking CLI calls to external APIs}
  spec.summary       = %q{Library for mocking CLI calls to external APIs}
  spec.homepage      = ""

  spec.files         = `git ls-files`.split($\)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.name          = "communist"
  spec.require_paths = ["lib"]
  spec.version       = Communist::VERSION

  spec.add_dependency 'rack'
  spec.add_dependency 'json'
  spec.add_dependency 'sinatra'

  spec.add_development_dependency 'bundler', '>= 1.5.0', '< 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
