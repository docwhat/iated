require 'spec_helper'

describe 'Iated /hello' do

  context "OPTIONS /hello" do
    subject do
      header "Origin", "null"
      options "/hello"
      last_response
    end

    it { should be_ok }
    its(:content_type) { should =~ /text\/plain/ }
    its(:body) { should == '' }

    it "should have access control allow origin turned off" do
      subject.headers['Access-Control-Allow-Origin'].should == 'null'
    end
  end
end
