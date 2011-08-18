require 'spec_helper'

describe 'IATed /doesnotexist' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "returns a 404 for a POST" do
    get '/doesnotexist'
    last_response.status.should == 404
    last_response.content_type =~ /text\/plain/
    last_response.body.should_not =~ /sinatra/i
  end

end
