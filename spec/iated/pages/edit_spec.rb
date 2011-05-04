require 'spec_helper'

describe 'IATed /edit' do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  def setup
    @authcode = '123456'
    @authtoken = 'iated-hello-auth-token'
    IATed::MCP.instance.should_recieve(:get_auth_code).and_return(@authcode)
    IATed::MCP.instance.should_recieve(:get_auth_token).with(@authcode).and_return(@authtoken)
  end

  it "returns 404 on GET" do
    get '/edit'
    last_response.status.should == 404
  end

  it "requires an auth-token" do
    post '/edit', { :auth_token => @authtoken }
    pending "get edit page working" do
      last_response.status.should == 200
      last_response.body.should == 'ok'
      last_response.content_type.should =~ /text\/html/
    end
  end
end
