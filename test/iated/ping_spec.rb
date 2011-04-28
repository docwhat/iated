describe 'IATed' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says ping" do
    get '/ping'
    last_response.should be_ok
    last_response.body.should == 'pong'
  end
end
