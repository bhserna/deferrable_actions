# -*- encoding: utf-8 -*-
require File.expand_path('../lib/deferrable_actions/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Benito Serna", "Jorge Gajon"]
  gem.email         = ["bhserna@gmail.com"]
  gem.description   = %q{A very simple way to defer a controller action, and execute it in another request.}
  gem.summary       = %q{Defer a controller action, and execute it later}
  gem.homepage      = "http://github.com/bhserna/deferrable_actions"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "deferrable_actions"
  gem.require_paths = ["lib"]
  gem.version       = DeferrableActions::VERSION

  gem.add_development_dependency "rspec"
end
