require 'digest/md5'
require 'set'

module IATed
    class EditSession
      attr_reader :url, :tid, :extension, :token

      ##
      # @param [Hash] options Various optional arguments (:url, :tid, :extension)
      def initialize options=nil
        options = normalize_keys options
        @url = options[:url]
        @tid = options[:tid]
        @extension = options[:extension]
        @change_id = 0
        @token = self.class.calculate_token options
        IATed::sessions[@token] = self
      end

      ## Finds an existing session
      def self.find search=nil
        if search.is_a? String
          tok = search
        else
          tok = calculate_token search
        end
        IATed::sessions[tok]
      end

      ## Finds an existing session or creates a new one
      def self.find_or_create search=nil
        sess = find search
        sess.nil? ? self.new(search) : sess
      end

      ## Calculate a token based on url, id, ext
      def self.calculate_token options
        options = normalize_keys options

        # TODO Should retrieve token from datastore if it exists.
        # TODO The token calculation needs a random number
        # TODO The token calculation needs the current time or date
        digest = Digest::MD5.new
        digest << "url: #{options[:url]}"
        digest << "id: #{options[:id]}"
        digest << "extension: #{options[:extension]}"
        return digest.hexdigest
      end

      ## Returns true if the editor is running.
      def running?
        # TODO This should check to see if a process is running or not.
        return false
      end

      ## Opens the user's configured editor.
      def edit
        raise "Not Done" # TODO implement edit
      end

      ## Returns the file where the session is saved.
      def filename
        raise "Not Done" # TODO implement save_file
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
