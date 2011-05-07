require 'pathname'
$: << (Pathname.new(__FILE__).dirname.dirname.dirname + 'src' + 'lib').to_s

require 'yaml'
require 'iated'

## Force the application name because polyglot breaks the auto-detection logic.
#Sinatra::Application.app_file = app_file

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
    Sinatra::Application
  end
end

World do
  MyWorld.new
end
