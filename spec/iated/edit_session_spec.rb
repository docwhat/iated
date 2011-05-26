require 'spec_helper'

describe IATed::EditSession do
  before(:each) do
    IATed::reset
  end
  after(:each) do
    IATed::reset
  end

  it "should be able to find existing sessions by params" do
    params = {:url => 'http://example.com/'}
    IATed::EditSession.new(params).should == IATed::EditSession.find(params)
  end

  it "should be able to find existing sessions by sid" do
    params = {:url => 'http://example.com/'}
    sess1 = IATed::EditSession.new(params)
    sess1.should == IATed::EditSession.find(sess1.sid)
  end

  it "should be able to find or create a session by exact match" do
    tid = "fc-tid#{rand(1000)}"

    sess1 = IATed::EditSession.find_or_create(:url => 'http://example.com/', :tid => tid)
    sess2 = IATed::EditSession.find_or_create(:url => 'http://example.com/', :tid => tid)

    sess1.should == sess2
  end

  context "#sid" do
    it "should be 32 character hex string" do
      tok = IATed::EditSession.calculate_sid :url => 'http://example.com/'
      tok.should =~ /^[a-f0-9]{32}$/
    end

    it "should be different for different extensions" do
      tok1 = IATed::EditSession.calculate_sid :url => "http://example.com", :extension => '.xml'
      tok2 = IATed::EditSession.calculate_sid :url => "http://example.com", :extension => '.txt'
      tok1.should_not == tok2
    end

    it "should be different for different urls" do
      tok1 = IATed::EditSession.calculate_sid :url => "http://example.com/a"
      tok2 = IATed::EditSession.calculate_sid :url => "http://example.com/b"
      tok1.should_not == tok2
    end

    it "should be different for different tids" do
      tok1 = IATed::EditSession.calculate_sid :url => "http://example.com/", :tid => 'a'
      tok2 = IATed::EditSession.calculate_sid :url => "http://example.com/", :tid => 'b'
      tok1.should_not == tok2
    end
  end

  context "#text" do
    it "should save the text when assigned" do
      text = "\t Random Number: #{rand}"
      sess = IATed::EditSession.new :url => 'http://example.com/', :text => text
      sess.filename.should be_exist
      sess.filename.read.should == text
    end

    it "should read back the text" do
      text = "\t Random Number: #{rand}"
      sess = IATed::EditSession.new :url => 'http://example.com/', :text => text
      sess.text.should == text
    end

    it "shouldn't touch the change_id on first save" do
      sess = IATed::EditSession.new :url => 'http://example.com/first_save_check', :tid => "#{rand}"
      sess.text = "first-save-foo"
      sess.change_id.should == 0
    end

    it "should increment the change_id on subsequent saves" do
      sess = IATed::EditSession.new :url => 'http://example.com/subseq_save_check', :tid => "#{rand}", :text => "sub-foo"
      sess.text = "sub-bar"
      sess.change_id.should == 1
    end
  end

  context "#increment_change_id" do
    it "should increment the #change_id" do
      sess = IATed::EditSession.new :url => 'http://example.com/'
      sess.change_id.should == 0
      sess.increment_change_id
      sess.change_id.should == 1
    end
  end

  context "param normalization" do
    it "should handle text keys the same as symbol keys" do
      [:url, :tid, :extension, :text].each do |key|
        h1 = {}
        h1[key] = 'stuff'
        h2 = {}
        h2[key.to_s] = 'stuff'
        p1 = IATed::EditSession.normalize_keys h1
        p2 = IATed::EditSession.normalize_keys h2
        p1.should == p2
      end
    end
  end
end
