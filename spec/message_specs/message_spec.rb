require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Messages

describe Message do
  
  it "should render SIF namespace and version" do
    msg = Message.new
    msg.Version.should == Siffer.sif_version
    Message.namespace.should == Siffer.sif_xmlns
  end
  
end