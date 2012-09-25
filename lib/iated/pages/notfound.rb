require 'sinatra'

not_found do
  content_type "text/plain"
  last_modified Time.now.httpdate
  "IATed doesn't respond to that."
end
