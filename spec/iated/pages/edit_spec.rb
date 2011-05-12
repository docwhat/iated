require 'spec_helper'

describe 'IATed /edit' do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  def last_yaml
    YAML::load(last_response.body)
  end

  context "creating a new edit session" do
    before(:each) do
      @token = IATed::mcp.generate_token 'bogus UA'
    end

    it "should return a session id" do
      post '/edit', { :token => @token,
                      :url => "http://example.com/return-a-session-id",
                      :text => 'sometext' }
      last_response.status.should == 200
      last_yaml[:sid].should_not be_nil
      IATed::sessions[last_yaml[:sid]].should_not be_nil
    end
  end

  context "working with existing session" do
    before(:each) do
      @session = IATed::EditSession.new :url => "http://example.com/existing", :text => "some text string."
      @sid = @session.sid
    end

    it "should return no changes" do
      post '/edit'
    end

  end
end
