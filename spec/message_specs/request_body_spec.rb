require File.join(File.dirname(__FILE__),"..","spec_helper")

describe Siffer::Messages::RequestBody do
  
  before(:each) do
    @xml = <<'EOF'
<SIF_Message version="2.2.0" xmlns="http://www.sifinfo.org/infrastructure/2.x">
	<SIF_Register>
		<SIF_Header>
		<SIF_MsgId>D0D297E0B732012BF1130016CB918E73</SIF_MsgId>
		<SIF_Timestamp>Sun Dec 28 10:28:07 -0700 2008</SIF_Timestamp>
		<SIF_SourceId>Clints Agent</SIF_SourceId>
		</SIF_Header>
	<SIF_Name>Clints Agent</SIF_Name>
	<SIF_Version>2.2.0</SIF_Version>
	<SIF_MaxBufferSize>1024</SIF_MaxBufferSize>
	<SIF_Mode>Pull</SIF_Mode>
	</SIF_Register>
</SIF_Message>
EOF
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
    ping = <<"PING"
<SIF_Message>
  <SIF_SystemControl>
    <SIF_Ping></SIF_Ping>
  </SIF_SystemControl>
</SIF_Message>
PING
    @msg = Siffer::Messages::RequestBody.parse(ping)
    @msg.type.should == "Ping"
  end
  
  it "should provide reasonable error message on failed type parse" do
    lambda {
      @msg = Siffer::Messages::RequestBody.parse("Hello World") 
      bad = @msg.type
    }.should raise_error("Failed to parse Hello World for SIF Type")
  end
  
  it "should parse source id" do
    @msg.source.should == "Clints Agent"
  end
  
  it "should parse msg id" do
    @msg.msg_id.should == "D0D297E0B732012BF1130016CB918E73"
  end
  
  it "should drop SIF_ from element names" do
    msg = Siffer::Messages::RequestBody.new("test")
    msg.send("drop_sif","SIF_Test").should == "Test"
  end
  
end