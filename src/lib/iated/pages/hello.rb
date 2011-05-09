require 'iated/mcp'
require 'sinatra'
require 'java'

get '/hello/?' do
  last_modified Time.now.httpdate
  if IATed::mcp.showing_secret?
    content_type "text/plain"
    response.status = 409
    return "busy"
  else
    IATed::mcp.show_secret
    content_type "text/plain"
    return "ok"
  end
end

post '/hello' do
  if IATed::mcp.confirm_secret params["secret"]
    content_type "text/yaml"
    token = IATed::mcp.generate_token env['HTTP_USER_AGENT']
    { :token => token }.to_yaml
  else
    halt 403
  end
end
