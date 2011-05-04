
# Load all handlers in the iated/ directory
Pathname.glob(Pathname.new(__FILE__).dirname + 'iated' + 'pages' + '*.rb').each do |path|
  require path.to_s
end

require 'iated/mcp'

set :run, false

$iated_mcp = IATed::MCP.new

module IATed
  class Application
    attr_reader :mcp

    #:nocov:
    def run
      if @mcp.nil?
        @mcp = IATed::MCP.new
      end
      @mcp.run!
    end
    #:nocov:

  end
end

