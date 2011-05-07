mcp = IATed::MCP.instance

Given /^I have not authenticated$/ do
  true
  #pending # express the regexp above with the code you wish you had
end

When /^I GET \/hello without a secret$/ do
  get "/hello"
end

When /^the page should be "([^"]*)"$/ do |content_type| #"
  last_response.content_type.should =~ Regexp.new("^#{Regexp.quote content_type}")
end

When /^the page should say "([^"]*)"$/ do |body| #"
  last_response.body.should == body
end

Then /^the user should be shown the secret$/ do
  mcp.is_showing_secret?.should be_true
end

When /^I POST \/hello with the secret$/ do
  post "/hello", :secret => mcp.secret
end

Then /^I should be sent a response with a token$/ do
  last_response.status.should == 200
  resp = YAML::load last_response.body
  resp[:token].should_not be_nil
end

When /^I POST \/preferences with the token$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should get a successful page$/ do
  pending # express the regexp above with the code you wish you had
end
