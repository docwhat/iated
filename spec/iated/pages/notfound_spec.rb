require 'spec_helper'

describe 'IATed /doesnotexist' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "returns a 404" do
    get '/doesnotexist'
    last_response.status.should == 404
    last_response.body.should_not =~ /sinatra/
  end
end
