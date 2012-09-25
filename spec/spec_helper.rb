
require 'pathname'
require 'rspec'
require 'rack/test'

$: << (Pathname.new(__FILE__).dirname.dirname + 'src' + 'lib').to_s

puts "Runing with #{RUBY_ENGINE}"

require 'iated'

set :environment, :test
IATed::environment = :test
