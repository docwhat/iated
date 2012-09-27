require 'spec_helper'

describe 'Iated pages' do
  describe "/preferences" do

    context "without authentication" do
      it "reports an error without a token" do
        get "/preferences"
        last_response.status.should == 403 # Forbidden
      end
    end


    context "authenticated" do
      before(:each) do
        Iated::reset
        @token = Iated::mcp.generate_token 'bogus UA'
      end

      it "returns a preferences web page" do
        get "/preferences", { :token => @token }
        last_response.status.should == 200
        last_response.content_type.should =~ /text\/html/
        last_response.body =~ /<h1>/i
      end

      it "returns a preferences web page" do
        post "/preferences", { :token => @token }
        last_response.content_type.should =~ /text\/html/
        last_response.body =~ /<h1>/i
      end
    end
  end

end
