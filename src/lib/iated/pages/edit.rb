require 'iated/mcp'
require 'sinatra'
require 'iated/page_helpers'

post '/edit' do
  requires_token
  session = IATed::EditSession.new params
  content_type "text/yaml"
  {:sid => session.sid}.to_yaml
end
