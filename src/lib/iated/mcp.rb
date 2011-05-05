## IATed Master Controller Package
# This is the coordination point for
# all the data stored, and the UI.

require 'sinatra'
require 'singleton'
require 'pathname'
require 'iated/browser_token_db'
require 'java'

module IATed
  class MCP < java.lang.Object
    include Singleton

    attr_accessor :debug
    attr_reader :iat_dir

    def initialize
      super
      @prefs = java.util.prefs.Preferences.userNodeForPackage(self.getClass)
      @debug = false
      @iat_dir = Pathname.new(java.lang.System.getProperty("user.home")) + ".iated"
      @iat_dir.mkdir unless @iat_dir.directory?
      @browser_token_db = IATed::BrowserTokenDB.new(@iat_dir + 'browser_tokens.yml')
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

    def auth_token
      if showing_auth_token?
        return @auth_token
      else
        return :notset
      end
    end

    def showing_auth_token?
      @is_showing_auth_token
    end

    def show_auth_token
      @auth_token = (1..4).map{ rand(10).to_s }.join ""
      @is_showing_auth_token = true
      Thread.new do
        puts " ** A browser requested authorization: #{@auth_token}"
# TODO This needs to be abstracted. There is no reason a purely command line version can't be done. Also, loading swing will break CI.
#        import javax.swing.JOptionPane
#        JOptionPane.showMessageDialog(nil,
#                                      "A browser has requested authorization: #{@auth_token}\nDo not press 'OK' until after you enter the number",
#                                      "Authorize Browser",
#                                      JOptionPane::INFORMATION_MESSAGE)
        @is_showing_auth_token = false
      end
    end

    def hide_auth_token
      # TODO auth_token should be using a JPanel or something, not a dialog.
    end

    # The magic value registering a browser.
    def get_browser_token user_agent
      @browser_token_db.add user_agent
    end

    def start_server
      # TODO this needs to be in a separate thread.
      set :server, %w[webrick]
      set :bind, 'localhost'
      set :port, port
      if @debug
        set :show_exceptions, true
        set :environment, :development
      else
        set :show_exceptions, false
        set :environment, :production
      end

      @is_running = true
      Sinatra::Application.run!
    end

    def stop_server
      @is_running = false
      Sinatra::Application.quit!
    end

  end
end
