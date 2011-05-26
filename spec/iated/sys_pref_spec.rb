require 'spec_helper'

describe SysPref do
  context "FakeStore" do
    before(:each) do
      IATed::reset
      @prefs = IATed.mcp.prefs
    end
    after(:each) do
      IATed::reset
    end

    context "#config_dir" do
      it "should return the same default value repeatedly" do
        first_value = @prefs.config_dir
        @prefs.config_dir.should == first_value
      end
    end
  end
end
