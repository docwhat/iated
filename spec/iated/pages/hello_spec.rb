require 'spec_helper'

describe 'IATed /hello' do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  def setup
    @authcode = '123456'
    @authtoken = 'iated-hello-auth-token'
    $iated_mcp.should_recieve(:get_auth_code).and_return(@authcode)
    $iated_mcp.should_recieve(:get_auth_token).with(@authcode).and_return(@authtoken)
  end

  it "returns ok to when greeted" do
    get '/hello'
    last_response.status.should == 200
    last_response.body.should == 'ok'
  end

  it "returns auth-token when code is sent" do
    post '/hello', {:auth => @authcode}
    pending "getting hello and auth working" do
      last_response.status.should == 200
      last_response.body.should_contain @authtoken
    end
  end

end
