require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Messages

describe Message do

  before(:each) do
    @message = Message.new("source_name") 
  end
  
  it "should have SIF version" do
    @message.version.should == "2.2.0"
  end
  
  it "should have SIF xml namespace" do
    @message.xmlns.should == "http://www.sifinfo.org/infrastructure/2.x"
  end
  
  it "should have a header" do
    @message.header.should_not be_nil
    @message.header.source_id.should == "source_name"
  end
  
  it "should raise exception for missing source identifier" do
    lambda{
      @message = Message.new(nil)
    }.should raise_error("Source not provided.")
  end
  
  it "should render SIF compliant instruct line" do
    @message.content.should match(/<SIF_Message/)
    @message.content.should match(/xmlns="#{Siffer.sif_xmlns}"/)
    @message.content.should match(/version="#{Siffer.sif_version}"/)
    @message.content.should match(/<\/SIF_Message>/)
  end
  
  it "should respond to 'to_str'" do
    @message.should respond_to("to_str")
    @message.to_str.should match(/SIF_Message/)
  end
      
end
