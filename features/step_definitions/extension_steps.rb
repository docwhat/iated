Given /^I have not authenticated$/ do
  @secret.should be_nil
  @token.should be_nil
end

When /^I GET (\/[a-z]+) without a secret$/ do |url|
  get url
end

When /^the page should be "([^"]*)"$/ do |content_type| #"
  last_response.content_type.should =~ Regexp.new("^#{Regexp.quote content_type}")
end

When /^the page should say "([^"]*)"$/ do |body| #"
  last_response.body.should == body
end

Then /^the user should be shown the secret$/ do
  IATed::mcp.should be_showing_secret
end

When /^I POST (\/[a-z]+) with the secret$/ do |url|
  post url, :secret => @secret
  last_response.status.should_not == 500
end

When /^I POST (\/[a-z]+) with the token$/ do |url|
  post url, :token => @token
end

Then /^I should be sent a response with a token$/ do
  last_response.status.should == 200
  resp = YAML::load last_response.body
  resp[:token].should_not be_nil
  @token = resp[:token]
end

Then /^the token should be registered$/ do
  IATed::mcp.is_token_valid?(@token).should be_true
end

Given /^I have a secret$/ do
  @secret.should be_nil
  @secret = IATed::mcp.generate_secret
  @secret.should_not be_nil
end

Given /^I have a token$/ do
  @token.should be_nil
  @token = IATed::mcp.generate_token "cucumber testing user agent"
  @token.should_not be_nil
end
