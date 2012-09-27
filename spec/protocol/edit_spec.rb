require 'spec_helper'
require 'json'

describe 'Iated /edit' do
  def last_json
    JSON::load(last_response.body)
  end

  before(:each) do
    Iated::reset
  end
  after(:each) do
    Iated::purge
  end

  context "creating a new edit session" do
    before(:each) do
      @token = Iated::mcp.generate_token 'bogus UA'
      post '/edit', { :token => @token,
                      :url => "http://example.com/create-a-new-edit-session",
                      :text => 'sometext' }
    end

    it "should return 200 (success)" do
      last_response.status.should == 200
    end

    it "should return a valid session id" do
      last_json["sid"].should_not be_nil
      Iated::sessions[last_json["sid"]].should_not be_nil
    end

    context "polling the new session" do
      before(:each) do
        @sid = last_json["sid"]
        get "/edit/#{@sid}/0"
      end
      it "should return 200 (success)" do
        last_response.status.should == 200
      end

      it "should return no changes" do
        last_json["change_id"].should == 0
      end

      it "should return no text" do
        last_json["text"].should be_nil
      end
    end

    context "after one change" do
      before(:each) do
        @sid = last_json["sid"]
        @text = "first_change"
        @session = Iated::sessions[@sid]
        @session.text = @text
        get "/edit/#{@sid}/0"
      end

      it "should return a change_id of 1" do
        last_json["change_id"].should == 1
      end

      it "should return the text" do
        last_json["text"].should == @text
      end
    end
  end

  context "repopening an existing file/session" do
    before(:each) do
      @token = Iated::mcp.generate_token 'bogus UA'
      post '/edit', { :token => @token,
                      :url => "http://example.com/reopen-an-existing"
      }
    end

    it "should return 200 (success)" do
      last_response.status.should == 200
    end

    it "should return a valid session id" do
      last_json["sid"].should_not be_nil
      Iated::sessions[last_json["sid"]].should_not be_nil
    end
  end

end
