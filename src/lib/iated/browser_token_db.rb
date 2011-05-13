require 'yaml'
require 'pathname'
require 'digest/md5'

module IATed
  ## The database for storing authorized browser tokens
  class BrowserTokenDB

    def initialize fname
      @fname = Pathname.new fname
      @tokens = {}

      # Write an empty file.
      if @fname.exist?
        read
      else
        write
      end
    end

    ## Add a token to the database.
    # This stores it persistently.
    # @return [String] the new token
    def add user_agent
      token = generate_token
      @tokens[token] = user_agent.to_s
      write
      return token
    end

    ## Does the token exist in the db?
    # @return [Boolean] Does this token exist in the store?
    def has_token? token
      @tokens.key? token
    end

    ## List of all tokens in DB.
    # @return [Array] All tokens stored in DB.
    def tokens
      @tokens.keys
    end

    ## What is the user_agent for the token?
    # @return [String] The user agent
    def user_agent token
      @tokens[token]
    end

    private

    ## Generate a token
    # @return [String] a hex string, 32 characters long
    def generate_token
      # FIXME this could be better.
      digest = Digest::MD5.new
      digest << Time.now.to_s
      digest << rand.to_s
      return digest.hexdigest
    end

    ## Write the data to the store
    # @return [nil]
    def write
      @fname.open('w') do |f|
        f.puts @tokens.to_yaml
      end
    end

    ## Read the data from the store
    # @return [nil]
    def read
      @tokens = YAML::load_file @fname.to_s
    end
  end
end
