require 'spec_helper'
require 'tmpdir'
require 'fileutils'
require 'pathname'

describe Iated::SysPref do
  let(:tmpdir) { Pathname.new Dir.mktmpdir("#{described_class}-") }
  subject { described_class.new tmpdir }
  after(:each) { tmpdir.rmtree }

  describe "#preferences" do
    it { described_class.preferences.should have_at_least(2).items }
    it "should contain Symbols" do
      described_class.preferences.each { |p| p.should be_a(Symbol) }
    end
  end

  describe ".preferences" do
    its(:preferences) { should eq(described_class::preferences) }
  end

  described_class.preferences.each do |preference|
    it { should respond_to(preference) }
    it { should respond_to("#{preference}=".to_sym) }
  end

  context "with no set values" do
    described_class.preferences.each do |preference|
      after(:each) { subject.send(preference) }

      it "should use default_#{preference}" do
        subject.should_receive("default_#{preference}")
      end
    end
  end

  its(:home) { should be_a(Pathname) }
  its(:home) { should be_a_directory }

  its(:port) { should be_a(Fixnum) }

  context "with the port set" do
    let(:port) { 2000 + rand(2000) }
    before(:each) { subject.port = port }

    its(:port) { should eq(port) }
  end

  its(:config_dir) { should be_a(Pathname) }
  its(:config_dir) { should be_a_directory }

  describe "config_dir" do
    it "should be the same on consecutive calls" do
      subject.config_dir.should eq(subject.config_dir)
    end
  end

  its(:editor) { should be_a(Pathname) }
  its(:editor) { should be_an_executable }

  context "on windows" do
    before do
      OS::stub(:windows?) . and_return(true)
      OS::stub(:posix?)   . and_return(false)
      OS::stub(:mac?)     . and_return(false)
    end

    its(:default_editor) { should eq(Pathname.new "notepad.exe") }
    its(:calculate_config_dir) { should eq(subject.home + "_iat") }
  end

  context "on unix" do
    before do
      OS::stub(:windows?) . and_return(false)
      OS::stub(:posix?)   . and_return(true)
      OS::stub(:mac?)     . and_return(false)
    end

    its(:default_editor) { should eq(Pathname.new "gedit") }
    its(:calculate_config_dir) { should eq(subject.home + '.iat') }
  end

  context "on mac" do
    before do
      OS::stub(:windows?) . and_return(false)
      OS::stub(:posix?)   . and_return(false)
      OS::stub(:mac?)     . and_return(true)
    end

    its(:default_editor) { should eq(Pathname.new "/Applications/TextEdit.app") }
    its(:calculate_config_dir) { should eq(subject.home + "Library" + "Application Support" + "It's All Text Editor Daemon") }
  end

  context "on unknown" do
    before do
      OS::stub(:windows?) . and_return(false)
      OS::stub(:posix?)   . and_return(false)
      OS::stub(:mac?)     . and_return(false)
    end

    its(:calculate_config_dir) { should eq(subject.home + '.iat') }
    its(:default_editor) { should eq(Pathname.new "") }
  end

end
