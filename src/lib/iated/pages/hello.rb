require 'iated/mcp'
require 'sinatra'
require 'iated/page_helpers'
require 'json'

helpers do 
  def request_headers
    env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
  end
end

get '/hello/?' do
  last_modified Time.now.httpdate
  if IATed::mcp.showing_secret?
    content_type "text/plain"
    response.status = 409
    return "busy"
  else
    IATed::mcp.show_secret
    content_type "text/json"
    return {:status => "ok"}.to_json
  end
end

post '/hello' do
  if IATed::mcp.confirm_secret params["secret"]
    content_type "text/json"
    token = IATed::mcp.generate_token env['HTTP_USER_AGENT']
    return {:token => token}.to_json
  else
    halt 403
  end
end
