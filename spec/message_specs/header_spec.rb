require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Messages

describe Message::Header do
  
  before(:each) do
    @header = Message::Header.new "source_name"  
  end
  
  it "should have a timestamp" do
    @header.timestamp.should_not be_nil
  end
  
  it "should have a GUID/UUID" do
    @header.msg_id.should_not be_nil
  end
  
  it "should have a GUID/UUID that matches SIF textual format" do
    @header = Message::Header.new "source_name"
    @header.msg_id.should_not match(/^[a-z\-\s]+$/)
    @header.msg_id.should match(/^[A-Z0-9]+$/)
  end
    
end
