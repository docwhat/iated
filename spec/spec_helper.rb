
require 'pathname'
require 'rspec'
require 'rack/test'

$: << (Pathname.new(__FILE__).dirname.dirname + 'src' + 'lib').to_s

puts "Runing with #{RUBY_ENGINE}"

require 'iated/server'

set :environment, :test
IATed::environment = :test

def app
  IATED::Server
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods, :example_group => { :file_path => /spec\/protocol/ }
end
