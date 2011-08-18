require 'spec_helper'

describe 'IATed pages' do
  describe "/preferences" do
    include Rack::Test::Methods
    def app
      Sinatra::Application
    end

    context "without authentication" do
      it "reports an error without a token" do
        get "/preferences"
        last_response.status.should == 403 # Forbidden
      end
    end


    context "authenticated" do
      before(:each) do
        IATed::reset
        @token = IATed::mcp.generate_token 'bogus UA'
      end

      it "returns a preferences web page" do
        get "/preferences", { :token => @token }
        last_response.status.should == 200
        last_response.content_type.should =~ /text\/html/
        last_response.body =~ /<h1>/i
      end
    end
  end

end
