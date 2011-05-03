require 'spec_helper'

describe 'IATed /edit' do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  it "returns 404 on GET" do
    get '/edit'
    last_response.status.should == 404
  end

  it "requires an auth-token" do
    post '/edit', { :auth_token => @authtoken }
    last_response.status.should == 200
    last_response.body.should == 'ok'
    last_response.content_type.should =~ /text\/html/
  end
end
