require 'spec_helper'

describe IATed::MCP do

  it "should be able to fetch the port number from preferences" do
    IATed::MCP.instance.port.should_not be_nil
  end

  it "should be able to set the port number to preferences" do
    mcp = IATed::MCP.instance
    old_port = mcp.port
    begin
      mcp.port = 1234
      mcp.port.should == 1234
    ensure
      # To be sure that the old port gets put back.
      mcp.port = old_port
    end
  end

  describe "#generate_browser_token" do
    it "should return a token" do
      mcp = IATed::MCP.instance
      token = mcp.generate_browser_token "bogus user agent string"
      token.should =~ /^[0-9a-f]{32}$/
    end
  end

end
