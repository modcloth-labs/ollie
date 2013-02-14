# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ollie/version'

Gem::Specification.new do |gem|
  gem.name          = "ollie"
  gem.version       = Ollie::VERSION
  gem.authors       = ["Nick Rowe"]
  gem.email         = ["n.rowe@modcloth.com"]
  gem.description   = %q{A status checker}
  gem.summary       = %q{A status checker that gives visibility into the systems that your app depends on}
  gem.homepage      = "https://github.com/modcloth/ollie"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
end
