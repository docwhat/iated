
require 'pathname'
require 'rspec'
require 'rack/test'

$: << (Pathname.new(__FILE__).dirname.dirname + 'src' + 'lib').to_s


require 'iated/server'

Iated::environment = :test

def app
  Iated::Server
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods, :example_group => { :file_path => /spec\/protocol/ }
end

puts "Running with #{RUBY_ENGINE} v#{RUBY_VERSION}"
