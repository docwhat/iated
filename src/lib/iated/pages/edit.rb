require 'iated/mcp'
require 'sinatra'
require 'iated/page_helpers'
require 'json'

post '/edit' do
  requires_token
  session = IATed::EditSession.new params
  # TODO: session.edit
  content_type "text/json"
  return {:sid => session.sid}.to_json
end

get '/edit/:sid/:change_id' do |sid, change_id|
  change_id = change_id.to_i
  session = IATed::sessions[sid]
  if session.nil?
    halt 404
  else
    content_type "text/json"
    resp = {
      :change_id => session.change_id,
    }
    if session.change_id > change_id
      resp[:text] = session.text
    end
    return resp.to_json
  end
end
