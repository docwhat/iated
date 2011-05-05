
require 'sinatra'

## Display the preferences web page.
get '/preferences' do
  erb :preferences
end

## Handle changes.
post '/preferences' do
  redirect '/preferences'
end
