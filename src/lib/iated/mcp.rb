## IATed Master Controller Package
# This is the coordination point for
# all the data stored, and the UI.

require 'sinatra'
require 'singleton'
require 'java'

module IATed
  class MCP < java.lang.Object
    include Singleton

    def initialize
      super
      @prefs = java.util.prefs.Preferences.userNodeForPackage(self.getClass)
    end

    ## Called by the main program to get everything started.
    def begin!
      start_server
    end

    ## Returns the current port number
    def port
      @prefs.getInt("PORT", defaultPort)
    end

    ## Returns the default port number.
    def defaultPort
      # TODO: This should probe for unused ports.
      9090
    end

    ## Sets the current port number
    def port= val
      @prefs.putInt("PORT", val.to_i)
    end

    def start_server
      set :server, %w[webrick]
      set :bind, 'localhost'
      set :port, port
      set :show_exceptions, true
      set :environment, :development

      @is_running = true
      Sinatra::Application.run!
    end

    def stop_server
      @is_running = false
      Sinatra::Application.quit!
    end

  end
end
