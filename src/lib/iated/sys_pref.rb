
require 'iated'
require 'java'
require 'pathname'
require 'tmpdir'

## Class to wrap the system preferences for the user.
#
# This either uses Java System Preferences (if production) or an in-memory store (if testing).
class SysPref
  # Why am I mucking around with JavaStore and FakeStore?
  #
  # Two reasons: It lets me drop in a fake version for testing and
  # because I want to use Java's System Preferences to persist preferences.

  ## Wrapper around Java's `java.util.prefs.Preferences`
  class JavaStore #< java.lang.Object
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

  ## Returns the current port number
  # @return [Integer] The port number
  def port
    store.getInt("PORT", default_port)
  end

  ## Sets the current port number
  # @return [nil]
  def port= val
    store.putInt("PORT", val.to_i)
    return nil
  end

  ## The directory where stuff is saved.
  # @return [Pathname] The configuration directory
  def config_dir
    Pathname.new store.get("CONFIG_DIR", default_config_dir)
  end

  ## Set the config directory.
  # @param [String] path The path to the config directory. Note: ~/ is expanded to `user.home`
  # @return [nil]
  def config_dir= path
    path = path.to_s.sub(/^~\//, home + '/')
    store.put("CONFIG_DIR", path)
    return nil
  end

  private

  ## Returns the default port number.
  def default_port
    # TODO: This should probe for unused ports.
    9090
  end

  ## Default config dir.
  def default_config_dir
    if IATed::environment == :test
      dir = Pathname.new(Dir.mktmpdir)
    else
      dir = Pathname.new(home)
      # FIXME Windows should probably use a different directory name.
      # FIXME Mac maybe should be in library?
    end
    dir = dir + '.iat'
    dir.mkdir unless dir.directory?
    return dir.to_s
  end

  def home
    java.lang.System.getProperty("user.home")
  end

  ## The actual object for storing preferences.
  #
  # Which store to use is determined by the IATed::environment
  def store
    @store ||= IATed::environment == :test ? FakeStore.new : JavaStore.new
  end

end
