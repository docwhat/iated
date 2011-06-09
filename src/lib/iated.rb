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

# Load all the jars in the lib directory.
Dir[File.join(File.dirname(__FILE__), '*.jar')].each do |jar|
  require jar
end


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
                "The port number to run the server on (default: #{IATed.mcp.prefs.port}).") do |p|
          IATed.mcp.prefs.port = p
        end

        opts.on('-e', '--editor EDITOR', "Set editor (default #{IATed.mcp.prefs.editor}).") do |editor|
          IATed.mcp.prefs.editor = editor
        end

        opts.on('-u', '--ui UI', "Set the UI to be 'gui' or 'text' (default #{IATed.mcp.ui}).") do |ui|
          IATed.mcp.ui = ui.to_sym
        end

        opts.on('-d', '--debug', "Turn on debugging mode.") do
          IATed.mcp.debug = true
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
      IATed.mcp.begin!
    end
    #:nocov:

  end

  # @return [Hash] Sessions
  def self.sessions
    # TODO This needs to be replaced with a real persistant data store.
    @sessions ||= {}
  end

  # The current environment
  # @return [Symbol] Returns one of: `:test`, `:development`, `:production`
  def self.environment
    @environment ||= :development
  end

  # Set the current environment
  # @return [Symbol] The symbol set.
  def self.environment= env
    if [:test, :development, :production].include? env
      @environment = env
      @mcp.prefs.reset unless @mcp.nil?
    else
      raise "Invalid IATed::environment specified: #{env.inspect}"
    end
  end

  ## Resets the Master Control Program, Preferences, and Sessions
  # @return [nil]
  def self.reset
    @mcp.prefs.reset unless @mcp.nil?
    @mcp = nil
    @sessions = nil
  end

  ## Access to the Master Control Program
  # @return [IATed::MCP]
  def self.mcp
    @mcp ||= IATed::MCP.new
  end

end

