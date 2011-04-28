
require 'rubygems'
require 'sinatra'

# Load all handlers in the iated/ directory
Pathname.glob(Pathname.new(__FILE__).dirname + 'iated' + 'pages' + '*.rb').each do |path|
  require path.to_s
end

require 'iated/mcp'

set :run, false

$iated_mcp = IATed::MCP.new

module IATed
  class Application
    def run

      set :server, %w[webrick]
      set :bind, 'localhost'
      set :port, 9494
      set :show_exceptions, true
      set :environment, :development

      Sinatra::Application.run!
    end
  end
end

