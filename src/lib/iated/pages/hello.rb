
require 'sinatra'

get '/hello' do
  content_type "text/plain"
  last_modified Time.now.httpdate
  "ok"
end
