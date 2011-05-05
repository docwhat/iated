
require 'sinatra'

get '/ping' do
  content_type "text/plain"
  last_modified Time.now.httpdate
  "pong"
end

get '/pong' do
  raise Exception, "Boom!"
end
