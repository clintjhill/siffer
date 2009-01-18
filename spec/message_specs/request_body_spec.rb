require File.join(File.dirname(__FILE__),"..","spec_helper")

describe Siffer::Messages::RequestBody do
  
  before(:each) do
    @xml = Siffer::Messages::Register.new("Clints Agent", "test server name")
    @msg = Siffer::Messages::RequestBody.parse(@xml)
  end
  
  it "should require 'read'able input" do
    lambda {
      Siffer::Messages::RequestBody.parse([])
    }.should raise_error("Unable to read Xml")
  end
  
  it "should allow StringIO input" do
    lambda {
      Siffer::Messages::RequestBody.parse(StringIO.new(@xml))
    }.should_not raise_error
  end
  
  it "should allow string input" do
    lambda {
      Siffer::Messages::RequestBody.parse(@xml)
    }.should_not raise_error
  end
  
  it "should parse message type" do
    @msg.type.should == "Register"
  end
  
  it "should parse message type within SystemControl" do
    ping = "<SIF_Message><SIF_SystemControl><SIF_Ping /></SIF_SystemControl></SIF_Message>"
    @msg = Siffer::Messages::RequestBody.parse(ping)
    @msg.type.should == "Ping"
  end
  
  it "should raise error when type not parsible" do
    lambda {
      Siffer::Messages::RequestBody.parse("<SIF_Message></SIF_Message>").type
    }.should 
      raise_error("Failed to parse <SIF_Message></SIF_Message> for SIF Type")
  end
  
  it "should parse source id" do
    @msg.source_id.should == @xml.source_id
  end
  
  it "should parse msg id" do
    @msg.msg_id.should == @xml.msg_id
  end
  
  it "should drop SIF_ from element names" do
    msg = Siffer::Messages::RequestBody.new("test")
    msg.send("drop_sif","SIF_Test").should == "Test"
  end
  
end