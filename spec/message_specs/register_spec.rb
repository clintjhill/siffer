require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Siffer::Messages::Register do
  
  it "should reqiure a name of the Registering Agent" do
    lambda {
      reg = Register.new("source",nil)
    }.should raise_error("Agent name required")
  end
  
end

describe Siffer::Messages::Register, "defaults" do
  
  before(:each) do
    @reg = Register.new("source", "agent")
  end
  
  it "should default to Siffer.version version" do
    @reg.version.should == Siffer.sif_version
  end
  
  it "should defaut to Pull mode" do
    @reg.mode.should == 'Pull'
  end
  
  it "should default to 1024 max buffer" do
    @reg.max_buffer.should == 1024
  end
  
  it "should default vendor to h3o(software)" do
    @reg.vendor.should == Siffer.vendor
  end
  
  it "should have a body containing agent name" do
    @reg.body.should match(/SIF_MaxBufferSize>1024<\/SIF_MaxBufferSize/)
  end
  
  it "should have a body containing max buffer size" do
    @reg.body.should match(/SIF_Name>agent<\/SIF_Name>/)
  end
  
  it "should respond to 'to_str'" do
    @reg.should respond_to("to_str")
    @reg.to_str.should match(/SIF_Message/)
  end
  
end