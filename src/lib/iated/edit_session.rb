require 'digest/md5'

class EditSession
  attr_reader :url, :id, :ext

  ##
  # @param [String] url -- The URL of the textarea.
  # @param [String] id  -- The ID of the textarea.
  # @param [String] ext -- The extension (file type) to edit with.
  def initialize url, id, ext
    @url = url
    @id = id
    @ext = ext
    @change_id = -1
  end

  ## Gets a new or existing session
  def self.getSession url, id, ext
    tok = calculate_token url, id, ext
    sess = IATed::MCP.instance.sessions tok
    if sess.nil?
      sess = self.new url, id, ext
    end
    return sess
  end

  ## Calculate a token based on url, id, ext
  def self.calculate_token url, id, ext
    # TODO Needs a real token calculator.
    # TODO Should retrieve token from datastore if it exists.
    digest = Digest::MD5.new
    digest << "url: #{url}"
    digest << "id: #{id}"
    digest << "ext: #{ext}"
    return digest.hexdigest
  end

  ## The session token
  def token
    self.calculate_token @url, @id, @ext
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
  
end
