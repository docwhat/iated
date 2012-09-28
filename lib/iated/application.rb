require 'iated/mcp'
require 'iated/browser_token_db'
require 'optparse'

module Iated
  class Application

    #:nocov:
    def initialize
      @mcp = nil
      @optparse = OptionParser.new do |opts|
        opts.banner =    "Usage: #{opts.program_name} [OPTIONS]"

        opts.on('-p', '--port PORT', Integer,
                "The port number to run the server on (default: #{Iated.mcp.prefs.port}).") do |p|
          Iated.mcp.prefs.port = p
        end

        opts.on('-e', '--editor EDITOR', "Set editor (default #{Iated.mcp.prefs.editor}).") do |editor|
          Iated.mcp.prefs.editor = editor
        end

        opts.on('-u', '--ui UI', "Set the UI to be 'gui' or 'text' (default #{Iated.mcp.ui}).") do |ui|
          Iated.mcp.ui = ui.to_sym
        end

        opts.on('-d', '--debug', "Turn on debugging mode.") do
          Iated.mcp.debug = true
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
      Iated.mcp.begin!
    end
    #:nocov:

  end

end
