require 'spec_helper'

describe 'IATed /preferences' do
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

  it "reports an error without an authtoken" do
    get "/preferences"
    pending "getting authtoken stuff working" do
      last_response.status.should == 403 # Forbidden
      last_response.status.should_not == 200
    end
  end

  it "returns a preferences web page" do
    get "/preferences", { :auth_token => @authtoken }
    pending "getting web pages working" do
      last_response.status.should == 200
      last_response.content_type.should =~ /text\/html/
      last_response.body =~ /<h1>/i
    end
  end

end
