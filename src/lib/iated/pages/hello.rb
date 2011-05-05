require 'iated/mcp'
require 'sinatra'
require 'java'

mcp = IATed::MCP.instance

get '/hello/?' do
  last_modified Time.now.httpdate
  if mcp.showing_auth_token?
    content_type "text/plain"
    response.status = 409
    return "busy"
  else
    mcp.show_auth_token
    if request.xhr?
      content_type "text/plain"
      return "ok"
    else
      return erb :hello
    end
  end
end

post '/hello' do
  # FIXME auth_token check should probably be done in MCP
  success = params["onetime"] == mcp.auth_token
  mcp.hide_auth_token
  if success
    auth_token = mcp.get_browser_token env['HTTP_USER_AGENT']
    response.set_cookie('iat_token',
                        :domain => nil,
                        :path => '/',
                        :value => auth_token,
                        :expires => Time.now + (60 * 60 * 24 * 365 * 10))
    redirect to('/')
  else
    halt 403
  end
end
