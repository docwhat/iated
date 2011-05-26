## Givens
Given /^I have not authenticated$/ do
  @secret.should be_nil
  @token.should be_nil
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

Given /^I have a new session$/ do
  @params = {}
  @params[:text] = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
  @params[:url] = "http://example.com/cucumber"
  @session = IATed::EditSession.new :url => @params
  @sid = @session.sid
end

Given /^the session has been edited (\d+) times$/ do |count|
  count.to_i.times.each do
    # This fakes that the file has been edited.
    @session.increment_change_id
  end
end

## Whens
When /^I GET (\/[a-z]+)( without a secret|)$/ do |url, junk|
  get url
end

When /^the page should be "([^"]*)"$/ do |content_type| #"
  last_response.content_type.should =~ Regexp.new("^#{Regexp.quote content_type}(;.*|)$")
end

When /^the page should say "([^"]*)"$/ do |body| #"
  last_response.body.should == body
end

When /^I POST (\/[a-z]+) with the secret$/ do |url|
  post url, :secret => @secret
  last_response.status.should_not == 500
end

When /^I POST (\/[a-z]+) with the token$/ do |url|
  post url, :token => @token
end

When /^I have a textarea to edit$/ do
  @textarea = {}
  @textarea[:text] = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ullamcorper metus lacinia risus congue sagittis. Integer enim libero, semper ut viverra eu, ullamcorper vitae urna. Quisque sit amet nibh urna, eget posuere nisi. Ut feugiat fermentum lacinia. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae congue turpis. Sed orci mi, eleifend ut tristique ac, vehicula ac erat. Integer nisl quam, dictum vel posuere non, semper adipiscing massa. Ut in lectus id arcu adipiscing interdum. Aliquam orci lectus, semper vitae varius eget, rutrum et ante. Aenean sagittis scelerisque augue, consectetur blandit elit sodales id. Proin nibh nunc, aliquam id porttitor quis, facilisis id ante. Morbi aliquet suscipit augue. Integer molestie nisi ut libero consectetur vel blandit erat sagittis."
end

When /^the textarea has the id of "([^"]*)"$/ do |tid| #"
  @textarea[:id] = tid
end

When /^the textarea has a url of "([^"]*)"$/ do |url| #"
  @textarea[:url] = url
end

When /^I request an extension of "(\.[a-z]+)"$/ do |extension|
  @textarea[:extension] = extension
end

When /^I POST an \/edit request$/ do
  @textarea[:token] = @token
  post "/edit", @textarea
end

When /^I GET \/edit\/<session id>\/(\d+)$/ do |change_id|
  get "/edit/#{@sid}/#{change_id}"
end

## Thens
Then /^the user should be shown the secret$/ do
  IATed::mcp.should be_showing_secret
end

Then /^I should be sent a response with a token$/ do
  last_response.status.should == 200
  last_yaml[:token].should_not be_nil
  @token = last_yaml[:token]
end

Then /^the token should be registered$/ do
  IATed::mcp.is_token_valid?(@token).should be_true
  # FIXME This is here because I'm having a hard time aggregating rcov reports.
  IATed::mcp.cucumber_coverage_check
end

Then /^I expect the text to be sent$/ do
  last_yaml[:text].should == @textarea[:text]
end

Then /^I expect a valid session id$/ do
  last_response.status.should == 200
  @sid = last_yaml[:sid]
  @sid.should_not be_nil
  @session = IATed::sessions[@sid]
  @session.should_not be_nil
end

Then /^I expect an editor to be opened$/ do
  @session.should be_running
end

Then /^I expect the editor file to have an extension of "(\.[a-z]+)"$/ do |ext|
  @session.extension.should == @textarea[:extension]
end

Then /^I expect the editor file to have "([a-z0-9._-]+)" in it$/ do |string|
  @session.filename.to_s.should =~ Regexp.new(Regexp.quote(string))
end

Then /^I expect a change\-count of (\d+)$/ do |change_count|
  last_yaml[:change_id].should == change_count.to_i
end

Then /^I expect no text to be sent$/ do
  last_yaml[:text].should be_nil
end
