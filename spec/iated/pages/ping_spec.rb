require 'spec_helper'

describe 'IATed /ping' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says pong" do
    get '/ping'
    last_response.should be_ok
    last_response.content_type.should =~ /text\/plain/
    last_response.body.should == 'pong'
  end
end
