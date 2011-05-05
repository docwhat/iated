require 'sinatra'

error do
  "There was an error of some sort - #{env['sinatra.error']}"
end

# We can add custom errors here as well:
#error MyCustomError do
#  'So what happened was...' + env['sinatra.error'].message
#end
