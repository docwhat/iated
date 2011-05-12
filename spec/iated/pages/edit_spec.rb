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
      @sid = @session.token
    end

    it "should return no changes" do
      post '/edit'
    end

  end
#  def setup
#    @authcode = '123456'
#    @authtoken = 'iated-hello-auth-token'
#    IATed::MCP.instance.should_recieve(:get_auth_code).and_return(@authcode)
#    IATed::MCP.instance.should_recieve(:get_auth_token).with(@authcode).and_return(@authtoken)
#  end
#
#  it "returns 404 on GET" do
#    get '/edit'
#    last_response.status.should == 404
#  end
#
#  it "requires an auth-token" do
#    post '/edit', { :auth_token => @authtoken }
#    pending "get edit page working" do
#      last_response.status.should == 200
#      last_response.body.should == 'ok'
#      last_response.content_type.should =~ /text\/html/
#    end
#  end
end
