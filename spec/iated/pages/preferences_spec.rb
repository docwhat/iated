require 'spec_helper'

describe 'IATed /preferences' do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  it "reports an error without an authtoken" do
    get "/preferences"
    last_response.status.should_not == 200
  end

  it "opens a preferences window" do
    get "/preferences", { :auth_token => @authtoken }
    last_response.status.should == 200
    last_response.body == 'ok'
  end

end
