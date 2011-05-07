require 'iated/mcp'
require 'sinatra'
require 'java'

mcp = IATed::MCP.instance

get '/hello/?' do
  last_modified Time.now.httpdate
  if mcp.is_showing_secret?
    content_type "text/plain"
    response.status = 409
    return "busy"
  else
    mcp.show_secret
    content_type "text/plain"
    return "ok"
  end
end

post '/hello' do
  # FIXME secret check should probably be done in MCP
  success = params["secret"] == mcp.secret
  mcp.hide_secret
  if success
    content_type "text/yaml"
    token = mcp.generate_browser_token env['HTTP_USER_AGENT']
    { :token => token }.to_yaml
  else
    halt 403
  end
end
