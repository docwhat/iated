require 'iated/mcp'
require 'sinatra'

post '/edit' do
  session = IATed::EditSession.new params
  content_type "text/yaml"
  {:sid => session.token}.to_yaml
end
