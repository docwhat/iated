require 'pathname'
$: << (Pathname.new(__FILE__).dirname.dirname + 'src' + 'lib').to_s

raise "I require JRuby" unless RUBY_ENGINE == "jruby"

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

require 'rspec'
require 'rack/test'
require 'iated'

set :environment, :test
IATed::environment = :test

# EOF
