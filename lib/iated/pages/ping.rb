
require 'sinatra'
require 'iated/page_helpers'

get '/ping' do
  content_type "text/plain"
  last_modified Time.now.httpdate
  "pong"
end

post '/ping' do
  requires_token
  content_type "text/plain"
  last_modified Time.now.httpdate
  "pong"
end

get '/pong' do
  raise Exception, "Boom!"
end
