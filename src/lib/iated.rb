
# Load all handlers in the iated/ directory
Pathname.glob(Pathname.new(__FILE__).dirname + 'iated' + 'pages' + '*.rb').each do |path|
  require path.to_s
end

require 'iated/mcp'
require 'optparse'

set :run, false

module IATed
  class Application
    attr_reader :mcp

    def initialize
      @optparse = OptionParser.new do |opts|
        opts.banner =    "Usage: #{opts.program_name} [OPTIONS]"

        opts.on('-p', '--port PORT', Integer,
                "The port number to run the server on (default: #{IATed::MCP.instance.port}.") do |p|
          IATed::MCP.instance.port = p
        end

        opts.on_tail('-h', '--help', 'Show this help.') do
          puts opts
          exit
        end
      end

    end

    #:nocov:
    def run
      @optparse.parse!
      IATed::MCP.instance.begin!
    end
    #:nocov:

  end
end

