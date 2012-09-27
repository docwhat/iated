require 'iated'

configure do
  class << Sinatra::Base
    def options(path, opts={}, &block)
      route 'OPTIONS', path, opts, &block
    end
  end
  Sinatra::Delegator.delegate :options
end

# Call this in a page to make sure
# that it returns a token.
def requires_token
  unless Iated.mcp.is_token_valid? params[:token]
    halt 403
  end
end

# This enables cross site scripting.
before do
  response['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN'] || '*'
end

options '/*' do
  content_type "text/plain"
  response['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN'] || '*'
  response['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
  response['Access-Control-Max-Age'] = '1000'
  response['Access-Control-Allow-Headers'] = 'X-REQUESTED-WITH'
  return ""
end

