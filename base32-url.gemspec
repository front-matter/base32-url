require 'date'
require File.expand_path('lib/base32/version', __dir__)

Gem::Specification.new do |s|
  s.authors       = 'Martin Fenner'
  s.email         = 'martin@front-matter.io'
  s.name          = 'base32-url'
  s.homepage      = 'https://github.com/front-matter/base32-url'
  s.summary       = '32-symbol notation for expressing numbers in a form that can be conveniently and accurately transmitted between humans'
  s.date          = Date.today
  s.description   = '32-symbol notation for expressing numbers in a form that can be conveniently and accurately transmitted between humans. URL-friendly version of the base32-crockford gem.'
  s.require_paths = ['lib']
  s.version       = Base32::Url::VERSION
  s.extra_rdoc_files = ['README.md']
  s.license = 'MIT'
  s.required_ruby_version = '>= 2.2'

  # Declary dependencies here, rather than in the Gemfile
  s.add_development_dependency 'bundler', '>= 1.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop', '~> 1.36'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  s.add_development_dependency 'simplecov', '0.22.0'
  s.add_development_dependency 'simplecov_json_formatter', '~> 0.1.4'
  s.add_development_dependency 'test-unit', '>= 3.2.3'

  s.files = `git ls-files`.split($/)
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
