require 'digest/md5'
require 'set'
require 'addressable/uri'

module IATed
    class EditSession
      attr_reader :url, :tid, :extension, :sid

      ##
      # @param [Hash] options Various optional arguments (:url, :tid, :extension)
      def initialize options=nil
        options = normalize_keys options
        @url = options[:url]
        @tid = options[:tid]
        @extension = options[:extension]
        @change_id = 0
        @sid = self.class.calculate_sid options
        IATed::sessions[@sid] = self
      end

      ## Finds an existing session
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
      def self.find_or_create search=nil
        sess = find search
        sess.nil? ? self.new(search) : sess
      end

      ## Calculate a sid based on url, id, ext
      def self.calculate_sid options
        options = normalize_keys options

        # TODO Should retrieve sid from datastore if it exists.
        # TODO The sid calculation needs a random number
        # TODO The sid calculation needs the current time or date
        digest = Digest::MD5.new
        digest << "url: #{options[:url]}"
        digest << "id: #{options[:id]}"
        digest << "extension: #{options[:extension]}"
        return digest.hexdigest
      end

      ## Returns true if the editor is running.
      def running?
        # TODO This should check to see if a process is running or not.
        return true
      end

      ## Opens the user's configured editor.
      def edit
        raise "Not Done" # TODO implement edit
      end

      ## Returns the file where the session is saved.
      def filename
        if @filename.nil?
          bad_chars = /[^a-zA-Z0-9._-]+/
          url = Addressable::URI.parse(@url)
          if url.host
            @filename = IATed::mcp.config_dir + url.host.gsub(bad_chars, '') + 
              "#{url.basename.gsub(bad_chars, '')}#{@extension}}"
          else
            @filename = IATed::mcp.config_dir + "#{@url.gsub(bad_chars, '')}#{@extension}"
          end
        end
        return @filename
      end

      ## Returns the text of the save_file
      def text
        raise "Not Done" # TODO implement save_file
      end

      ## Returns the current change_id.
      def change_id
        raise "Not Done" # TODO implement save_file
      end

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

      def normalize_keys hash
        self.class.normalize_keys hash
      end

      private

    end
end
