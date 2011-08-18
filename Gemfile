# -*- ruby -*-
source 'http://rubygems.org'

gem 'sinatra', "~>1.2.6"
gem 'addressable', "~>2.2.5"
gem 'json'

group :development do
  gem 'rake'
  gem 'guard'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'spork', '~> 0.9.0rc'
  #gem 'guard-spork' # While spork works in jruby guard-spork doesn't seem to. :-(
  gem 'rb-fsevent'
  gem 'growl'
end

group :development, :test do
  gem 'warbler', "~>1.3.0"
  gem 'rspec'
  gem 'ci_reporter'
  gem "rcov"
  gem 'cucumber'
  gem 'webrat'
  gem 'yard'
  gem 'kramdown'
  gem 'nokogiri'
end

group :test do
  gem 'rack-test'
end
