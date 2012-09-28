require 'iated/version'

if RUBY_ENGINE == "jruby"
  # Load all the jars in the lib directory.
  Dir[File.join(File.dirname(__FILE__), '*.jar')].each do |jar|
    require jar
  end
end

module Iated
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
      raise "Invalid Iated::environment specified: #{env.inspect}"
    end
  end

  ## Resets the Master Control Program, Preferences, and Sessions
  # @return [nil]
  def self.reset
    @mcp.prefs.reset unless @mcp.nil?
    @mcp = nil
    @sessions = nil
  end

  ## Deletes all state from the system
  # @return [nil]
  def self.purge
    dir = self.mcp.prefs.config_dir
    dir.rmtree if dir.directory?
  end

end

