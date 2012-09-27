require 'spec_helper'

describe 'Iated /hello' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "returns options" do
    header "Origin", "null"
    options "/hello"
    last_response.should be_ok
    last_response.content_type.should =~ /text\/plain/
    last_response.headers['Access-Control-Allow-Origin'].should == 'null'
    last_response.body.should == ''
  end
end
