# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar_inception/version'

Gem::Specification.new do |gem|
  gem.name          = "ar_inception"
  gem.version       = ArInception::VERSION
  gem.authors       = ["Robert Sanders"]
  gem.email         = ["robert@zeevex.com"]
  gem.description   = %q{Extension to ActiveRecord 3.x to provide parallel transaction scopes.}
  gem.summary       = %q{Extension to ActiveRecord 3.x to provide parallel transaction scopes.}
  gem.homepage      = "http://github.com/zeevex/parallel_transaction_scope"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '>= 2.9.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'mysql'
end
