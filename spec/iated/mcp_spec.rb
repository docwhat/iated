require 'spec_helper'

describe "IATed::mcp" do

  it "should be able to fetch the port number from preferences" do
    IATed::mcp.port.should_not be_nil
  end

  it "should be able to set the port number to preferences" do
    mcp = IATed::mcp
    old_port = mcp.port
    begin
      mcp.port = 1234
      mcp.port.should == 1234
    ensure
      # To be sure that the old port gets put back.
      mcp.port = old_port
    end
  end

  context "while showing a secret" do
    before(:each) do
      IATed::mcp.show_secret
    end
    after(:each) do
      IATed::mcp.hide_secret
    end
    describe "#secret" do
      it "should be a string" do
        IATed::mcp.secret.should be_a_kind_of(String)
      end
      it "should be 4 digits" do
        IATed::mcp.secret.should =~ /^[0-9]{4}$/
      end
    end
    describe "#showing_secret?" do
      it "should be true" do
        IATed::mcp.should be_showing_secret
      end
    end
    describe "#confirm_secret" do
      it "should return true if secret matches" do
        IATed::mcp.confirm_secret(IATed::mcp.secret).should be_true
      end
      it "should return false if secret doesn't match" do
        IATed::mcp.confirm_secret("qqqq").should be_false
      end
      it "should stow showing the secret" do
        IATed::mcp.confirm_secret(IATed::mcp.secret)
        IATed::mcp.should_not be_showing_secret
      end
    end
  end

  context "while not showing a secret" do
    describe "#secret" do
      it "should return :notset" do
        IATed::mcp.secret.should == :notset
      end
    end
    describe "#showing_secret?" do
      it "should be false" do
        IATed::mcp.should_not be_showing_secret
      end
    end
  end


  describe "#generate_token" do
    before(:each) do
      @token = IATed::mcp.generate_token "bogus user agent string"
    end
    it "should return a 32 hex character token" do
      IATed::mcp.rspec_coverage_check
      @token.should =~ /^[0-9a-f]{32}$/
    end
    it "should return a different token each time" do
      token2 = IATed::mcp.generate_token "bogus user agent string"
      @token.should_not == token2
    end
  end

  describe "#ui" do
    it "should only accept :test, :text, and :gui" do
      IATed::mcp.ui = :gui
      IATed::mcp.ui = :text
      IATed::mcp.ui = :test
      lambda { IATed::mcp.ui = nil }.should raise_error
      lambda { IATed::mcp.ui = :flibbit }.should raise_error
    end
  end

  describe "#sessions" do
    it "should return a session keeper" do
      IATed::sessions.should be_a_kind_of(IATed::SessionKeeper)
    end
  end
end
