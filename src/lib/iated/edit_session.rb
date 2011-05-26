require 'digest/md5'
require 'set'
require 'addressable/uri'

module IATed
  ## An Edit Session
  #
  # A single session for editing a textarea. It tracks the editor, etc.
  class EditSession
    # @return [String,nil] The URL the textarea came from
    attr_reader :url
    # @return [String,nil] The textarea id
    attr_reader :tid
    # @return [String,nil] The extension the text file should use
    attr_reader :extension
    # @return [String] The session id
    attr_reader :sid
    # @return [Integer] The number of changes recorded to the file
    attr_reader :change_id

    ##
    # @param [Hash] options Various optional arguments (:url, :tid, :extension)
    def initialize options=nil
      normalized_options = normalize_keys options
      @url               = normalized_options[:url]
      @tid               = normalized_options[:tid]
      @extension         = normalized_options[:extension]
      @change_id         = 0
      @sid               = self.class.calculate_sid normalized_options

      # Save session.
      IATed::sessions[@sid] = self

      # Save the text, if passed in the original options
      if options.key? :text
        self.text = options[:text]
      end
    end

    ## Finds an existing session
    # @return [EditSession]
    def self.find search=nil
      # TODO Once the sid is random, then find needs to work via a data store.
      if search.is_a? String
        tok = search
      else
        tok = calculate_sid search
      end
      IATed::sessions[tok]
    end

    ## Finds an existing session or creates a new one
    # @return [EditSession]
    def self.find_or_create search=nil
      sess = find search
      sess.nil? ? self.new(search) : sess
    end

    ## Calculate a sid based on url, id, ext
    # @return [String] A session id
    def self.calculate_sid options
      options = normalize_keys options

      # TODO Should retrieve sid from datastore if it exists.
      # TODO The sid calculation needs a random number
      # TODO The sid calculation needs the current time or date
      digest = Digest::MD5.new
      digest << "url: #{options[:url]}"
      digest << "tid: #{options[:tid]}"
      digest << "extension: #{options[:extension]}"
      return digest.hexdigest
    end

    ## Increment the change_id
    # @return [Integer] The new number of changes
    def increment_change_id
      @change_id = @change_id + 1
    end

    ## Returns true if the editor is running.
    # @return [Boolean] True if the editor is running
    def running?
      # TODO This should check to see if a process is running or not.
      return true
    end

    ## Opens the user's configured editor.
    def edit
      raise "Not Done" # TODO implement edit
    end

    ## Returns the file where the session is saved.
    # @return [Pathname] The filename and path the text was saved to.
    def filename
      if @filename.nil?
        bad_chars = /[^a-zA-Z0-9._-]+/
        url = Addressable::URI.parse(@url)
        config_dir = IATed::mcp.prefs.config_dir
        if url.host
          # TODO Handle case where url is the root and filename is empty.
          @filename = config_dir + url.host.gsub(bad_chars, '') +
            "#{url.basename.gsub(bad_chars, '')}#{@extension}"
        else
          @filename = config_dir + "#{@url.gsub(bad_chars, '')}#{@extension}"
        end
      end
      return @filename
    end

    ## Returns the text of the filename
    def text
      if filename.exist?
        filename.read
      else
        nil
      end
    end

    def text= value
      increment_change_id if filename.exist?
      filename.dirname.mkdir unless filename.dirname.directory?
      # TODO locking
      filename.open('w') do |f|
        f.write value
      end
    end

    ## Normalizes the search options (`:url`, `:tid`, `:extension`)
    #
    # Used by other functions
    # @return [Hash]
    def self.normalize_keys hash=nil
      norm_hash = {}
      hash = {} if hash.nil?

      [:url, :tid, :extension].each do |key|
        norm_hash[key] = hash[key] || hash[key.to_s] || (:extension == key ? '.txt' : nil)
      end

      # Verify the keys are sane. We ignore :text.
      accepted_keys = Set.new((hash.keys + [:text]).map {|x| [x, x.to_s]}.flatten)
      unexpected_keys = Set.new(hash.keys) - accepted_keys
      raise "Invalid keys: #{unexpected_keys.inspect}" if unexpected_keys.count > 0
      return norm_hash
    end

    ## Alias for the class-method `normalize_keys`
    # @see IATed::EditSession.normalize_keys
    # @return [Hash]
    def normalize_keys hash
      self.class.normalize_keys hash
    end

    private

  end
end
