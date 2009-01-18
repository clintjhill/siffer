require File.join(File.dirname(__FILE__),"..","spec_helper")

describe Siffer::Messages::Status do
  it "should return message for each status code" do
    Siffer::Messages::Status::CODES.each do |key,value|
      msg = Siffer::Messages::Status.send(value.downcase)
      msg.should_not be_nil
      msg.code.should == key
      msg.description.should == value
      msg.data.should be_nil
    end
  end
  
  it "should have a SIF_Status element body" do
    success = Siffer::Messages::Status.success
    success.read.should match(/SIF_Status/)
    success.read.should match(/SIF_Code>0<\/SIF_Code/)
    success.read.should match(/SIF_Description>Success</)
  end
  
  it "should allow data to hold other SIF_Message(s)" do
    data = Siffer::Messages::Status.success(Siffer::Messages::Message.new("source"))
    data.read.should match(/SIF_Data><SIF_Message/)
  end
end