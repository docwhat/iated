## IATed Master Controller Package
# This is the coordination point for
# all the data stored, and the UI.

require 'sinatra'
require 'pathname'
require 'iated/sys_pref'
require 'iated/browser_token_db'
require 'java'

module IATed
  ## The Master Control Progrom
  #
  # Yes, I've been watching Tron lately, why do ask?
  class MCP

    attr_accessor :debug

    attr_reader :browser_token_db

    # @return [SysPref] The current System Preferencs object
    attr_reader :prefs

    def initialize
      @debug = false
      @prefs = SysPref.new
      @browser_token_db = IATed::BrowserTokenDB.new(@prefs.config_dir + 'browser_tokens.yml')
    end

    ## Called by the main program to get everything started.
    def begin!
      start_server
    end

    # @return [String,Symbol] The currently showing secret or the symbol `:notset`
    def secret
      showing_secret? ? @secret : :notset
    end

    ## Confirm the secret
    #
    # @param [String] guess The string to check against the secret
    # @return [Boolean] Was the guess right?
    def confirm_secret guess
      success = (guess == secret)
      hide_secret
      return success
    end

    # @return [Boolean] Is the secret being shown to the user?
    def showing_secret?
      @is_showing_secret
    end

    ## Show the secret to the user
    # @return [nil]
    def show_secret
      generate_secret
      # TODO This should do something different for text, vs. gui.
      puts " ** A browser requested authorization: #{@secret}" unless :test == ui
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

    ## Hide the secret again
    # @return [nil]
    def hide_secret
      @is_showing_secret = false
      # TODO secret should be using a JPanel or something, not a dialog.
    end

    ## The magic value shown to user to confirm a connection
    # @return [String] The string
    def generate_secret
      @secret = (1..4).map{ rand(10).to_s }.join ""
      @is_showing_secret = true
      return @secret
    end

    ## The magic value registering a browser.
    # @return [String] The token
    def generate_token user_agent
      @browser_token_db.add user_agent
    end

    ## Is the auth token a valid one?
    # @return [Boolean] True if the token is valid and exist
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
      @ui ||= (:test == IATed.environment ? :test : :text)
    end

    def start_server
      # TODO this needs to be in a separate thread.
      set :server, %w[webrick]
      set :bind, 'localhost'
      set :port, prefs.port
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
