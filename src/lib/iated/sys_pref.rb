require 'iated'
require 'pathname'
require 'tmpdir'

if RUBY_ENGINE == "jruby"
  require 'java'
end


## Class to wrap the system preferences for the user.
#
# This either uses Java System Preferences (if production) or an in-memory store (if testing).
class SysPref
  # Why am I mucking around with JavaStore and FakeStore?
  #
  # Two reasons: It lets me drop in a fake version for testing and
  # because I want to use Java's System Preferences to persist preferences.

  if RUBY_ENGINE == 'jruby'
    ## Wrapper around Java's `java.util.prefs.Preferences`
    class JavaStore < java.lang.Object
      def initialize
        super
        @store = java.util.prefs.Preferences.userNodeForPackage(self.getClass)
      end
      # @return [Integer]
      def getInt key, default
        @store.getInt key.to_s, default.to_i
      end
      # @return [nil]
      def putInt key, value
        @store.putInt key.to_s, value.to_i
      end
      # @return [String]
      def get key, default
        @store.get key.to_s, default.to_s
      end
      # @return [nil]
      def put key, value
        @store.put key.to_s, value.to_s
      end
    end
  end

  ## An in-memory replacement for {JavaStore}
  class FakeStore
    def initialize
      @store = {}
    end
    # @return [Integer]
    def getInt key, default
      (@store[key.to_s] || default).to_i
    end
    # @return [nil]
    def putInt key, value
      @store[key.to_s] = value.to_i
    end
    # @return [String]
    def get key, default
      (@store[key.to_s] || default).to_s
    end
    # @return [nil]
    def put key, value
      @store[key.to_s] = value.to_s
    end
  end

  def self.preferences
    @preferences ||= []
  end

  def self.integer_pref name, default
    preferences << name
    jpref_name = name.to_s.upcase

    define_method name do
      store.getInt(jpref_name, send(default))
    end

    define_method "#{name}=".to_sym do |value|
      store.putInt(jpref_name, value.to_i)
      return nil
    end
  end

  def self.filename_pref name, default
    preferences << name
    jpref_name = name.to_s.upcase

    define_method name do
      Pathname.new store.get(jpref_name, send(default))
    end

    define_method "#{name}=".to_sym do |path|
      path = path.to_s.sub(/^~\//, home + '/')
      store.put(jpref_name, path)
      return nil
    end
  end

  integer_pref  :port,       :default_port
  filename_pref :config_dir, :default_config_dir
  filename_pref :editor,     :default_editor

  ## Resets the preferences module
  # @return [nil]
  def reset
    @test_dir.rmtree unless @test_dir.nil?
    @test_dir = nil
    @store = nil
  end

  ## User's home directory
  # @return [String]
  def home
    if RUBY_ENGINE == 'jruby'
      java.lang.System.getProperty("user.home")
    else
      ENV['HOME']
    end
  end

  private

  ## Returns the default port number.
  def default_port
    # TODO: This should probe for unused ports.
    9090
  end

  ## Default config dir.
  # @return [String]
  def default_config_dir
    if IATed::environment == :test
      @test_dir = Pathname.new(Dir.mktmpdir) if @test_dir.nil?
      dir = @test_dir
    else
      dir = Pathname.new(home)
      # FIXME Windows should probably use a different directory name.
      # FIXME Mac maybe should be in ~/Library?
    end
    dir = dir + '.iat'
    dir.mkdir unless dir.directory?
    return dir.to_s
  end

  def os
    if RUBY_ENGINE == 'jruby'
      if os.isFamilyMac
        return :mac
      elsif os.isFamilyUnix
        return :unix
      elsif os.isFamilyWindows or os.isFamilyWin9x
        return :windows
      else
        return :unknown
      end
    else
      if RUBY_PLATFORM =~ /darwin/
        return :mac
      elsif RUBY_PLATFORM =~ /win/
        return :windows
      else # It's unix?
        return :unix
      end
    end
  end

  ## Default editor to use.
  # @return [String]
  def default_editor
    if os == :mac
      return "/Applications/TextEdit.app"
    elsif os == :unix
      return "gvim"
    elsif os == :windows
      return "notepad.exe"
    else
      return ""
    end
  end

  ## The actual object for storing preferences.
  #
  # Which store to use is determined by the IATed::environment
  def store
    unless @store
      if IATed::environment == :test
        @store ||= FakeStore.new
      else
        if RUBY_ENGINE == "jruby"
          @store ||= JavaStore.new
        else
          @store ||= FakeStore.new
        end
      end
    end
    return @store
  end

end
