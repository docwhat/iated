require 'spec_helper'

describe 'IATed /edit' do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  def last_yaml
    YAML::load(last_response.body)
  end

  context "creating a new edit session" do
    before(:each) do
      IATed::reset
      @token = IATed::mcp.generate_token 'bogus UA'
      post '/edit', { :token => @token,
                      :url => "http://example.com/create-a-new-edit-session",
                      :text => 'sometext' }
    end

    it "should return 200 (success)" do
      last_response.status.should == 200
    end

    it "should return a valid session id" do
      last_yaml[:sid].should_not be_nil
      IATed::sessions[last_yaml[:sid]].should_not be_nil
    end

    context "polling the new session" do
      before(:each) do
        @sid = last_yaml[:sid]
        get "/edit/#{@sid}/0"
      end
      it "should return 200 (success)" do
        last_response.status.should == 200
      end

      it "should return no changes" do
        last_yaml[:change_id].should == 0
      end

      it "should return no text" do
        last_yaml[:text].should be_nil
      end
    end
  end

  context "working with existing session" do
    before(:each) do
      IATed::reset
      @session = IATed::EditSession.new :url => "http://example.com/existing", :text => "some text string."
      @sid = @session.sid
    end

    context "after one change" do
      before(:each) do
        @text = "first_change"
        @session.text = @text
        get "/edit/#{@sid}/0"
      end

      it "should return a change_id of 1" do
        last_yaml[:change_id].should == 1
      end

      it "should return the text" do
        last_yaml[:text].should == @text
      end
    end

  end
end
