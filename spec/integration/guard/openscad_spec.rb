require 'spec_helper'
require 'guard/openscad'

# I am aware that I have stubs in an integration test.
# I am just trying to rush out the outline of a full Guard.

describe Guard::Openscad do
  context "finding the Openscad Guard" do
    it "should be a Guard::Guard" do
      should be_a(Guard::Guard)
    end
  end

  context "group should not be nil" do
    its(:group) { should eql(:default) }
  end

  context "initializing" do
    it "should accept watches and options" do
      described_class.new([:watches],{options: :accepted})
    end
  end

  context "'s generated template" do
    before do
      Guard.stub(:locate_guard).and_return(FileUtils.pwd)
    end

    let(:scanner) { StringScanner.new(guard_template) }
    let(:guard_template) { described_class.template(:openscad) }

    subject { guard_template }

    it { should include "group :csg do" }

    context "csg group" do
      subject { scanner.scan_until(/group :csg do\n/) ; scanner.rest }

      it "should guard openscad" do
        should include("guard :openscad")
      end

      it "should be configured for the csg format" do
        should include(", format: :csg do")
      end

      it "should watch all scad files in scad/" do
        should include("watch(%r{^scad/.+\\.scad$})")
      end
    end
  end
end
