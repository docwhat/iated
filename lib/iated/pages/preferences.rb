
require 'sinatra'
require 'iated/helpers'

## Display the preferences web page.
get '/preferences' do
  requires_token
  haml :preferences
end

## Handle changes.
post '/preferences' do
  # TODO require_authtoken params
  redirect to('/preferences')
end
