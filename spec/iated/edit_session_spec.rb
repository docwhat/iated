require 'spec_helper'

describe IATed::EditSession do
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

  context "sid calculations" do
    it "should be able to calculate sids" do
      tok = IATed::EditSession.calculate_sid :url => 'http://example.com/'
      tok.should =~ /^[a-f0-9]{32}$/
    end

    it "should be able to reliably calculate sids" do
      tok1 = IATed::EditSession.calculate_sid :url => "http://example.com"
      tok2 = IATed::EditSession.calculate_sid :url => "http://example.com", :extension => '.txt'
      tok3 = IATed::EditSession.calculate_sid :url => "http://example.com", :tid => nil
      tok4 = IATed::EditSession.calculate_sid :url => "http://example.com/differet"
      tok1.should == tok2
      tok1.should == tok3
      tok1.should_not == tok4
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
