require 'iated/mcp'
require 'sinatra'
require 'iated/page_helpers'

post '/edit' do
  requires_token
  session = IATed::EditSession.new params
  content_type "text/yaml"
  {:sid => session.sid}.to_yaml
end

get '/edit/:sid/:change_id' do |sid, change_id|
  change_id = change_id.to_i
  session = IATed::sessions[sid]
  if session.nil?
    halt 404
  else
    resp = {
      :change_id => session.change_id,
    }
    if session.change_id > change_id
      resp[:text] = session.text
    end
    return resp.to_yaml
  end
end
