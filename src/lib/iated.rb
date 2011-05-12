require 'pathname'
# Load all handlers in the iated/ directory
Pathname.glob(Pathname.new(__FILE__).dirname + 'iated' + 'pages' + '*.rb').each do |path|
  require path.to_s
end

require 'sinatra'
require 'iated/mcp'
require 'iated/edit_session'
require 'iated/browser_token_db'
require 'optparse'

# Global settings for Sinatra
set :run, false
set :views, (Pathname.new(__FILE__).dirname.dirname + 'views').to_s
set :public, (Pathname.new(__FILE__).dirname.dirname + 'public').to_s

module IATed
  class Application

    #:nocov:
    def initialize
      @mcp = nil
      @optparse = OptionParser.new do |opts|
        opts.banner =    "Usage: #{opts.program_name} [OPTIONS]"

        opts.on('-p', '--port PORT', Integer,
                "The port number to run the server on (default: #{IATed::MCP.instance.port}).") do |p|
          mcp.port = p
        end

        opts.on('-d', '--debug', "Turn on debugging mode.") do
          mcp.debug = true
        end

        opts.on_tail('-h', '--help', 'Show this help.') do
          puts opts
          exit
        end
      end

    end
    #:nocov:

    #:nocov:
    def run
      @optparse.parse!
      mcp.begin!
    end
    #:nocov:

  end

  def self.sessions
    # TODO This needs to be replaced with a real persistant data store.
    @sessions ||= {}
  end

  def self.environment
    @environment ||= :development
  end

  def self.environment= env
    if [:test, :development, :production].include? env
      @environment = env
    else
      raise "Invalid IATed::environment specified: #{env.inspect}"
    end
  end

  ## Resets the Master Control Program
  def self.reset_mcp
    @mcp = nil
  end

  ## Access to the Master Control Program
  def self.mcp
    @mcp ||= IATed::MCP.new
  end

end

