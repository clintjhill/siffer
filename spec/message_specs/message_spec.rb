require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Messages

describe Header do
  
  before(:each) do
    @header = Header.new(:source_id => "source_name")  
  end
  
  it "should require source_id" do
    Header.should require(:source_id)
  end
  
  it "should have a timestamp" do
    @header.timestamp.should_not be_nil
  end
  
  it "should have a GUID/UUID" do
    @header.msg_id.should_not be_nil
  end
  
  it "should have a GUID/UUID that matches SIF textual format" do
    @header.msg_id.should_not match(/^[a-z\-\s]+$/)
    @header.msg_id.should match(/^[A-F0-9]{32}$/)
  end
    
end

describe Security do
  
  it "should require SecureChannel" do
    Security.should require(:secure_channel)
  end
  
end

describe SecureChannel do
  
  it "should require authentication level" do
    SecureChannel.should require(:authentication_level)
  end
  
  it "should require encryption level" do
    SecureChannel.should require(:encryption_level)
  end
  
end

describe Message do
  
  it "should require Header" do
    Message.should require(:header)
  end
  
  it "should require Header when subclassed" do
    class Subbed < Message
      element :doozy
    end
    Subbed.should require(:header)
  end
  
  it "should have SIF version attribute" do
    @message = Message.new(:source_id => "Test Source")
    @message.class_attributes[:version].should == Siffer.sif_version
  end
  
  it "should have SIF xml namespace attribute" do
    @message = Message.new(:source_id => "Test Source")
    @message.class_attributes[:xmlns].should == Siffer.sif_xmlns
  end
      
end

describe Contexts do
  
  it "should require a Context" do
    Contexts.should require(:context)
  end
  
end
