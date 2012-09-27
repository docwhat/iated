require 'rubygems'
require 'bundler/setup'

require 'pathname'
$: << (Pathname.new(__FILE__).dirname.dirname.dirname + 'src' + 'lib').to_s

require 'yaml'
require 'json'
require 'iated/server'

## Force the application name because polyglot breaks the auto-detection logic.
#Sinatra::Application.app_file = app_file

set :environment, :test
Iated::environment = :test

require 'rspec/expectations'
require 'rack/test'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

class MyWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Iated::Server
  end

  def last_yaml
    YAML::load(last_response.body)
  end

  def last_json
    JSON::load(last_response.body)
  end
end

World do
  MyWorld.new
end
