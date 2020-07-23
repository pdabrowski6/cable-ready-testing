# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cable_ready/testing/version'

Gem::Specification.new do |spec|
  spec.name          = 'cable-ready-testing'
  spec.version       = CableReady::Testing::VERSION

  spec.authors       = ['Paweł Dąbrowski']
  spec.email         = ['pawel.dabrowski.k1@gmail.com']

  spec.summary       = 'Testing utils for Cable Ready'
  spec.description   = 'Testing utils for Cable Ready'
  spec.homepage      = 'http://github.com/pdabrowski6/cable-ready-testing'
  spec.license       = 'MIT'

  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_dependency 'actioncable', '>= 5.0'
  spec.add_dependency 'cable_ready', '>= 4.0'

  spec.add_development_dependency 'rspec-rails', '~> 3.5'
  spec.add_development_dependency 'rubocop'
end
