# -*- encoding: utf-8 -*-
require File.expand_path('../lib/giraffi/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "giraffi"
  gem.version     = Giraffi::Version.to_s
  gem.platform    = Gem::Platform::RUBY
  gem.author      = "azukiwasher"
  gem.email       = "azukiwasher@higanworks.com"
  gem.homepage    = "http://github.com/giraffi/giraffi"
  gem.summary     = %q{Giraffi API wrapper}
  gem.description = %q{A Ruby wrapper for the Giraffi API.}
  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}

  gem.files = `git ls-files`.split("\n")
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.rubyforge_project = "giraffi"
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_dependency = "multi_json", "~> 1.0"
  gem.add_dependency = "httparty", "~> 0.7"
  gem.add_dependency = "addressable", "~> 2.2"
  gem.add_development_dependency = "shoulda"
  gem.add_development_dependency = "bundler"
  gem.add_development_dependency = "rcov"
  gem.add_development_dependency = "webmock"
  gem.add_development_dependency = "turn"
  gem.add_development_dependency = "watchr"
  gem.add_development_dependency = "spork-testunit"
  gem.add_development_dependency = "minitest"
  gem.add_development_dependency = "rb-fsevent"
  gem.add_development_dependency = "mocha"
  gem.add_development_dependency = "yard"
end
