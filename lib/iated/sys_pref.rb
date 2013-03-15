require 'pathname'
require 'tmpdir'
require 'pstore'
require 'OS'

module Iated
  ## Class to wrap the system preferences for the user.
  #
  class SysPref
    # @return [Pathname] The location of the system preference file
    attr_reader :storage_path

    # @param [Pathname,String] config_dir Override the configuration directory. Useful for testing.
    def initialize( config_dir=nil )
      @config_dir = Pathname.new(config_dir) unless config_dir.nil?
    end

    # @return [Array] A list of all the editable preferences.
    def self.preferences
      @preferences ||= []
    end

    # @return [Array] A list of all the editable preferences. Alias for {Iated::SysPref::preferences}.
    def preferences
      p self.class
      self.class.preferences
    end

    ## Define a preference.
    #
    # Creates the setter and getter for a preference.  You can also set a coercion method as
    # a passed in block.
    #
    # There must be a `default_<name>` method to provide the default for the preference.
    #
    # @param [Symbol] name The name of a preference to define
    # @yield [value] The value for the block to coerce. You should only use ruby built-ins since the value will be mashalled.
    # @return [nil]
    def self.define_preference name
      name = name.to_sym
      default = "default_#{name}".to_sym
      preferences << name

      define_method name do
        value = store.transaction do
          store[name]
        end

        if value.nil?
          return send(default)
        else
          return value
        end
      end

      define_method "#{name}=".to_sym do |value|
        value = yield(value) if block_given?
        store.transaction { store[name] = value }
        return nil
      end
    end

    define_preference(:port)       { |v| v.to_i }
    define_preference(:editor)     { |v| Pathname.new(v) }

    ## User's home directory
    # @return [Pathname]
    def home
      Pathname.new RUBY_ENGINE == 'jruby' ?  java.lang.System.getProperty("user.home") : ENV['HOME']
    end

    # @return [Fixnum] Returns the default port number.
    def default_port
      # TODO: This should probe for unused ports.
      9090
    end

    # @return [Pathname] The configuration directory.
    def config_dir
      @config_dir ||= calculate_config_dir
    end

    # @return [Symbol] Returns the Operating System: `:mac`, `:unix`, `:windows`, `:unknown`
    def os
      return :windows if OS.windows?
      return :mac if OS.mac?
      return :unix if OS.posix?
      return :unknown
    end

    # @return [Pathname] The default editor to use.
    def default_editor
      editor = if os == :mac
                 "/Applications/TextEdit.app"
               elsif os == :unix
                 "gedit"
               elsif os == :windows
                 "notepad.exe"
               else
                 ""
               end
      return Pathname.new editor
    end

    # @return [Pathname] Returns the location of the configuration file used by the {Iated::SysPref}
    def config_file
      (config_dir + 'config')
    end

    # @return [PStore] Returns the store object.
    def store
      @store ||= PStore.new config_file.to_s
    end

    private

    # @return [Pathname] Returns the configuration directory based on OS.
    def calculate_config_dir
      config_dir = home
      if :windows == os
        config_dir += '_iat'
      elsif :mac == os
        config_dir = config_dir + 'Library' + 'Application Support' +  "It's All Text Editor Daemon"
      else
        config_dir += '.iat'
      end
      config_dir.mkdir unless config_dir.directory?
      return config_dir
    end
  end
end
