require 'spec_helper'

describe "Iated::mcp" do

  it "should be able to fetch the port number from preferences" do
    Iated::mcp.prefs.port.should_not be_nil
  end

  it "should be able to set the port number to preferences" do
    mcp = Iated::mcp
    mcp.prefs.port = 1234
    mcp.prefs.port.should == 1234
  end

  context "while showing a secret" do
    before(:each) do
      Iated::mcp.show_secret
    end
    after(:each) do
      Iated::mcp.hide_secret
    end
    describe "#secret" do
      it "should be a string" do
        Iated::mcp.secret.should be_a_kind_of(String)
      end
      it "should be 4 digits" do
        Iated::mcp.secret.should =~ /^[0-9]{4}$/
      end
    end
    describe "#showing_secret?" do
      it "should be true" do
        Iated::mcp.should be_showing_secret
      end
    end
    describe "#confirm_secret" do
      it "should return true if secret matches" do
        Iated::mcp.confirm_secret(Iated::mcp.secret).should be_true
      end
      it "should return false if secret doesn't match" do
        Iated::mcp.confirm_secret("qqqq").should be_false
      end
      it "should stow showing the secret" do
        Iated::mcp.confirm_secret(Iated::mcp.secret)
        Iated::mcp.should_not be_showing_secret
      end
    end
  end

  context "while not showing a secret" do
    describe "#secret" do
      it "should return :notset" do
        Iated::mcp.secret.should == :notset
      end
    end
    describe "#showing_secret?" do
      it "should be false" do
        Iated::mcp.should_not be_showing_secret
      end
    end
  end


  describe "#generate_token" do
    before(:each) do
      @token = Iated::mcp.generate_token "bogus user agent string"
    end
    it "should return a 32 hex character token" do
      Iated::mcp.rspec_coverage_check
      @token.should =~ /^[0-9a-f]{32}$/
    end
    it "should return a different token each time" do
      token2 = Iated::mcp.generate_token "bogus user agent string"
      @token.should_not == token2
    end
  end

  describe "#ui" do
    it "should only accept :test, :text, and :gui" do
      Iated::mcp.ui = :gui
      Iated::mcp.ui = :text
      Iated::mcp.ui = :test
      lambda { Iated::mcp.ui = nil }.should raise_error
      lambda { Iated::mcp.ui = :flibbit }.should raise_error
    end
  end
end
