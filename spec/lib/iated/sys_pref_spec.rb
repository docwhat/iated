require 'spec_helper'
require 'pathname'

describe SysPref do
  context "FakeStore" do
    before(:each) do
      IATed::reset
      @prefs = IATed.mcp.prefs
    end
    after(:each) do
      IATed::reset
    end

    context "#home" do
      it "should return the home directory as a string" do
        @prefs.home.should be_a(String)
      end
    end

    context "#port" do
      it "should return the correct value" do
        @prefs.port = 2020
        @prefs.port.should == 2020
      end
    end

    context "#config_dir" do
      it "should return the same default value repeatedly" do
        first_value = @prefs.config_dir
        @prefs.config_dir.should == first_value
      end
    end

    context "#editor" do
      it "should be able to load the jar to calculate the default" do
        @prefs.editor.should be_a Pathname
      end
    end
  end
end
