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
      element :doozy, :type => :mandatory
    end
    Subbed.should require(:header)
  end
  
  it "should have SIF version attribute" do
    Message.class_attributes[:version].should == Siffer.sif_version
  end
  
  it "should have SIF xml namespace attribute" do
    Message.class_attributes[:xmlns].should == Siffer.sif_xmlns
  end
  
  it "should parse XML" do
    xml = Ack.new(:header => "Test Ack", :original_source_id => "Original Msg", :original_msg_id => "12345ABCDE", :status => Status.new(:code => 0))
    body = Message.parse(xml)
    body.should be_instance_of(Ack)
    body.header.msg_id.should eql(xml.header.msg_id) # real parsing - not recreation
  end
  
  it "should parse nested instances of XML" do
    xml = SystemControl.cancel_requests("test cancel", NOTIFICATION_TYPES[:none], "1111","2222","3333")
    body = Message.parse(xml)
    body.should be_instance_of(SystemControl)
    body.system_control_data.should be_instance_of(CancelRequests) #assure nested instances
  end
  
  it "should parse raw SIF Spec Ack example" do
    #example lifted from SIF Spec 2.3 Example 5.2.1-1: SIF_Ack
    xml = "<SIF_Message Version=\"2.3\" xmlns=\"http://www.sifinfo.org/infrastructure/2.x\"><SIF_Ack><SIF_Header><SIF_MsgId>AB1058CD3261545A31905937B265CE01</SIF_MsgId><SIF_Timestamp>2006-02-18T08:39:40-08:00</SIF_Timestamp><SIF_SourceId>SifInfo_TestZIS</SIF_SourceId></SIF_Header><SIF_OriginalSourceId>RamseyLib</SIF_OriginalSourceId><SIF_OriginalMsgId>1298ACEF3261545A31905937B265CE01</SIF_OriginalMsgId><SIF_Status><SIF_Code>0</SIF_Code><SIF_Data><SIF_Message Version=\"2.3\"><SIF_Request><SIF_Header><SIF_MsgId>A3E90785EFDA330DACB00785EFDA330D</SIF_MsgId><SIF_Timestamp>2006-02-18T08:39:02-08:00</SIF_Timestamp><SIF_SourceId>RamseySIS</SIF_SourceId></SIF_Header><SIF_Version>2.*</SIF_Version><SIF_MaxBufferSize>1048576</SIF_MaxBufferSize><SIF_Query><SIF_QueryObject ObjectName=\"LibraryPatronStatus\" /><SIF_ConditionGroup Type=\"None\"><SIF_Conditions Type=\"None\"><SIF_Condition><SIF_Element>@SIF_RefObject</SIF_Element><SIF_Operator>EQ</SIF_Operator><SIF_Value>StaffPersonal</SIF_Value></SIF_Condition></SIF_Conditions></SIF_ConditionGroup></SIF_Query></SIF_Request></SIF_Message></SIF_Data></SIF_Status></SIF_Ack></SIF_Message>"
    body = Message.parse(xml)
    body.should be_instance_of(Ack)
    body.status.code.should eql("0")
    # This sucks ... need better way to recurse messages
    body.status.data.data.should be_instance_of(Request)
  end
  
  it "should parse raw SIF Spec Provide example" do
    # example lifted from SIF Spec 2.3 Example 5.2.3-1: SIF_Provide
    xml = "<SIF_Message Version=\"2.3\" xmlns=\"http://www.sifinfo.org/infrastructure/2.x\"><SIF_Provide><SIF_Header><SIF_MsgId>34DC87FE3261545A31905937B265CE01</SIF_MsgId><SIF_Timestamp>2006-02-18T20:39:12-08:00</SIF_Timestamp><SIF_SourceId>RamseySIS</SIF_SourceId></SIF_Header><SIF_Object ObjectName=\"StudentPersonal\" /><SIF_Object ObjectName=\"StudentSchoolEnrollment\" /></SIF_Provide></SIF_Message>"
    body = Message.parse(xml)
    body.should be_instance_of(Provide)
    body.should have(2).object
  end
  
  it "should parse raw SIF Spec Request example" do
    # example lifted from SIF Spec 2.3 Example 5.2.6-1: SIF_Request
    xml = "<SIF_Message Version=\"2.3\" xmlns=\"http://www.sifinfo.org/infrastructure/2.x\"><SIF_Request><SIF_Header><SIF_MsgId>A3E90785EFDA330DACB00785EFDA330D</SIF_MsgId><SIF_Timestamp>2006-02-18T20:39:12-08:00</SIF_Timestamp><SIF_SourceId>RamseySIS</SIF_SourceId></SIF_Header><SIF_Version>2.*</SIF_Version><SIF_MaxBufferSize>1048576</SIF_MaxBufferSize><SIF_Query><SIF_QueryObject ObjectName=\"LibraryPatronStatus\" /><SIF_ConditionGroup Type=\"None\"><SIF_Conditions Type=\"None\"><SIF_Condition><SIF_Element>@SIF_RefObject</SIF_Element><SIF_Operator>EQ</SIF_Operator><SIF_Value>StaffPersonal</SIF_Value></SIF_Condition><SIF_Condition><SIF_Operator>EQ</SIF_Operator><SIF_Value>StaffTester</SIF_Value><SIF_Element>@SIF_RefObjectTester</SIF_Element></SIF_Condition></SIF_Conditions></SIF_ConditionGroup></SIF_Query></SIF_Request></SIF_Message>"
    body = Message.parse(xml)
  end
  
end

describe Contexts do
  
  it "should require a Context" do
    Contexts.should require(:context)
  end
  
end
