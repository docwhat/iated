## IATed Master Controller Package
# This is the coordination point for
# all the data stored, and the UI.

require 'sinatra'
require 'pathname'
require 'iated/browser_token_db'
require 'java'

module IATed
  class MCP < java.lang.Object

    attr_accessor :debug
    attr_reader :iat_dir
    attr_reader :browser_token_db

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
      @prefs.getInt("PORT", default_port)
    end

    ## Sets the current port number
    # @return [nil]
    def port= val
      @prefs.putInt("PORT", val.to_i)
    end

    ## Returns the default port number.
    def default_port
      # TODO: This should probe for unused ports.
      9090
    end

    ## The directory where stuff is saved.
    # @return [Pathname]
    def config_dir
      Pathname.new @prefs.get("CONFIG_DIR", default_config_dir)
    end

    ## Set the config directory.
    # @return [nil]
    def config_dir= path
      @prefs.put("CONFIG_DIR", val.to_s)
    end

    ## Default config dir.
    def default_config_dir
      dir = Pathname.new(java.lang.System.getProperty("user.home"))
      # FIXME Windows should probably use a different directory name.
      # FIXME Mac maybe should be in library?
      dir = dir + "/.iat/"
      return dir.to_s
    end

    def secret
      showing_secret? ? @secret : :notset
    end

    def confirm_secret guess
      success = (guess == secret)
      hide_secret
      return success
    end

    def showing_secret?
      @is_showing_secret
    end

    def show_secret
      generate_secret
##      Thread.new do
##        puts " ** A browser requested authorization: #{@secret}"
### TODO This needs to be abstracted. There is no reason a purely command line version can't be done. Also, loading swing will break CI.
###        import javax.swing.JOptionPane
###        JOptionPane.showMessageDialog(nil,
###                                      "A browser has requested authorization: #{@secret}\nDo not press 'OK' until after you enter the number",
###                                      "Authorize Browser",
###                                      JOptionPane::INFORMATION_MESSAGE)
##        @is_showing_secret = false
##      end
    end

    def hide_secret
      @is_showing_secret = false
      # TODO secret should be using a JPanel or something, not a dialog.
    end

    # The magic value shown to user to confirm a connection
    def generate_secret
      @secret = (1..4).map{ rand(10).to_s }.join ""
      @is_showing_secret = true
      return @secret
    end

    # The magic value registering a browser.
    def generate_token user_agent
      @browser_token_db.add user_agent
    end

    def is_token_valid? token
      @browser_token_db.has_token? token
    end

    def ui= ui_type
      if [:text, :test, :gui].include? ui_type
        @ui = ui_type
      else
        raise "Invalid UI type: #{ui_type.inspect}"
      end
    end

    def ui
      # Default UI
      @ui ||= :text
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

    def cucumber_coverage_check
      @cucumber_check = true
    end

    def rspec_coverage_check
      @rspec_check = true
    end

  end
end
