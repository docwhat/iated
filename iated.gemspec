# -*- encoding: utf-8 -*-
require File.expand_path('../lib/iated/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christian Höltje"]
  gem.email         = ["docwhat@gerf.org"]
  gem.description   = %q{The It's All Text! Editor Daemon}
  gem.summary       = <<-EOF
  This is the core IAT Editor Daemon functionality as a gem.

  It comes with the command line version of `iated` that
  gives you all the functionality of the GUI versions.
  EOF
  gem.homepage      = "http://github.com/docwhat/iated"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "iated"
  gem.require_paths = ["lib"]
  gem.license       = 'MIT'
  gem.version       = Iated::VERSION

  gem.add_runtime_dependency "sinatra", "~> 1.3", ">= 1.3.3"
  gem.add_runtime_dependency "haml", "~> 3.1", ">= 3.1.7"
  gem.add_runtime_dependency "json", "~> 1.1"
  gem.add_runtime_dependency "addressable", "~> 2.3", ">= 2.3"
  gem.add_runtime_dependency "coffee-script"
  gem.add_runtime_dependency "sass"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "> 2.0"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "kramdown"

  gem.add_development_dependency "cucumber", ">= 1.1.0"
  gem.add_development_dependency "webrat"
  gem.add_development_dependency "syntax"
  gem.add_development_dependency "rack-test"

  gem.add_development_dependency "guard", ">= 1.3.0"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-cucumber"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "terminal-notifier-guard"
  gem.add_development_dependency "growl"
end
