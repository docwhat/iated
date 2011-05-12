require 'spec_helper'

describe IATed::EditSession do
  it "should be able to create new sessions" do
    IATed::EditSession.new.should be_a_kind_of IATed::EditSession
    IATed::EditSession.new(:url => 'http://example.com/').should be_a_kind_of IATed::EditSession
  end

  it "should be able to find existing sessions" do
    session = IATed::EditSession.new(:url => 'http://example.com/')
    found = IATed::EditSession.find( :url => "http://example.com" )
    found.should == session
  end

  it "should be able to calculate tokens" do
    tok = IATed::EditSession.calculate_token :url => 'http://example.com/'
    tok.should =~ /^[a-f0-9]{32}$/
  end

  it "should be able to find or create a session by parameters"

  it "should be able to find sessions by text"

  it "should be able to find sessions by url"

  it "should be able to find sessions by tid"

  it "should be able to find sessions by extension"

end
