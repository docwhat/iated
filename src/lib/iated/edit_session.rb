require 'digest/md5'

module IATed
    class EditSession
      attr_reader :url, :tid, :extension

      ##
      # @param [Hash] options -- Various optional arguments (:url, :tid, :ext)
      def initialize options = {}
        options = normalize_keys options
        @url = options[:url]
        @tid = options[:tid]
        @extension = options[:extension]
        @change_id = 0
        tok = calculate_token
        IATed::sessions[tok] = self
      end

      ## Gets a new or existing session
      def self.find search = {}
        tok = calculate_token search
        IATed::sessions[tok]
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

      ## The session token
      def calculate_token
        self.class.calculate_token :url => @url, :tid => @tid, :extension => @extension
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
      def save_file
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

      def self.normalize_keys hash
        norm_hash = {}
        [:url, :tid, :extension].each do |key|
          norm_hash = hash[key] || (:extension == key ? '.txt' : nil)
          hash.delete key
        end
        raise "Invalid keys: #{hash.keys.inspect}" if hash.count > 0
        return norm_hash
      end

      def normalize_keys hash
        self.class.normalize_keys hash
      end

      private

    end
end
