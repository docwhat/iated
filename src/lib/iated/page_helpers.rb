require 'iated'

# Call this in a page to make sure
# that it returns a token.
def requires_token
  unless IATed.mcp.is_token_valid? params[:token]
    halt 403
  end
end
