require 'spec_helper'
require 'pathname'
require 'tmpdir'

describe IATed::BrowserTokenDB do

  it "writes to a specified file" do
    Dir.mktmpdir do |dir|
      fname = Pathname.new(dir) + 'test.yml'
      db = IATed::BrowserTokenDB.new fname
      fname.exist?.should be_true
    end
  end

  it "doesn't have tokens that don't exist" do
    Dir.mktmpdir do |dir|
      fname = Pathname.new(dir) + 'test.yml'
      db = IATed::BrowserTokenDB.new fname
      db.has_token?("random-token").should be_false
      db.user_agent("random_token").should be_nil
    end
  end

  it "stores tokens and reads them back" do
    Dir.mktmpdir do |dir|
      ua = "NCSA_Mosaic/2.7b5 (X11;Linux 2.6.7 i686) libwww/2.12"
      fname = Pathname.new(dir) + 'test.yml'
      db = IATed::BrowserTokenDB.new fname
      tok = db.add ua
      db.has_token?(tok).should be_true
      db.user_agent(tok).should == ua
    end
  end

  it "stores tokens and reads them back persistantly" do
    Dir.mktmpdir do |dir|
      ua = "NCSA_Mosaic/2.7b5 (X11;Linux 2.6.7 i686) libwww/2.12"
      fname = Pathname.new(dir) + 'test.yml'
      db = IATed::BrowserTokenDB.new fname
      tok = db.add ua
      db = nil

      db2 = IATed::BrowserTokenDB.new fname
      db2.has_token?(tok).should be_true
      db2.user_agent(tok).should == ua
    end
  end

  it "tokens are always strings" do
    Dir.mktmpdir do |dir|
      fname = Pathname.new(dir) + 'test.yml'
      db = IATed::BrowserTokenDB.new fname
      tok = db.add "user agent"
      tok.should be_an_instance_of String
    end
  end

  it "user agents are always strings" do
    Dir.mktmpdir do |dir|
      fname = Pathname.new(dir) + 'test.yml'
      db = IATed::BrowserTokenDB.new fname
      tok = db.add :user_agent
      db.user_agent(tok).should be_an_instance_of String
    end
  end

end
