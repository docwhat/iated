require 'spec_helper'

describe "IATed MCP" do
  it "should be able to fetch the port number from preferences" do
    mcp = IATed::MCP.new
    mcp.port.should_not be_nil
  end

  it "should be able to set the port number to preferences" do
    mcp = IATed::MCP.new
    old_port = mcp.port
    begin
      mcp.port = 1234
      mcp.port.should == 1234
    ensure
      # To be sure that the old port gets put back.
      mcp.port = old_port
    end
  end

end
