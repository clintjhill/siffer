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
  
end

describe Siffer::Messages::Register, "overrides" do
  it "should allow sif version override" do
    reg = Register.new("source","agent",:version => '9.9')
    reg.version.should == '9.9'
  end
  
  it "should allow max_buffer override" do
    reg = Register.new("source", "agent", :max_buffer => 2048)
    reg.max_buffer.should == 2048
  end
  
  it "should allow mode override" do
    reg = Register.new("source", "agent", :mode => 'Push')
    reg.mode.should == "Push"
  end
end

describe Siffer::Messages::Register, "content" do
  
  before(:each) do
    @reg = Register.new("source", "agent")
  end
  
  it "should have max buffer size" do
    @reg.content.should match(/SIF_MaxBufferSize>1024<\/SIF_MaxBufferSize/)
  end
  
  it "should have agent name" do
    @reg.content.should match(/SIF_Name>agent<\/SIF_Name>/)
  end
  
  it "should parse name from body" do
    Register.parse(@reg.content).name.should == "agent"
  end
  
  it "should parse SIF version from body" do
    Register.parse(@reg.content).version.should == Siffer.sif_version
  end
  
  it "should parse max buffer size from body" do
    Register.parse(@reg.content).max_buffer.should == 1024
  end
  
  it "should parse mode from body" do
    Register.parse(@reg.content).mode.should == "Pull"
  end
  
end