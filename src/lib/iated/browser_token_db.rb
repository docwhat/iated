require 'yaml'
require 'pathname'
require 'digest/md5'

module IATed
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
    def add user_agent
      token = generate_token
      @tokens[token] = user_agent.to_s
      write
      return token
    end

    ## Does the token exist in the db?
    def has_token? token
      @tokens.key? token
    end

    ## List of all tokens in DB.
    def tokens
      @tokens.keys
    end

    ## What is the user_agent for the token?
    def user_agent token
      @tokens[token]
    end

    private

    def generate_token
      # FIXME this could be better.
      digest = Digest::MD5.new
      digest << Time.now.to_s
      digest << rand.to_s
      return digest.hexdigest
    end

    def write
      @fname.open('w') do |f|
        f.puts @tokens.to_yaml
      end
    end

    def read
      @tokens = YAML::load_file @fname.to_s
    end
  end
end
