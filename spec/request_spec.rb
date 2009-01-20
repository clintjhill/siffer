require File.join(File.dirname(__FILE__), "spec_helper")

describe Siffer::Request do  
  it "should provide access to the body as a SIF_Message (Siffer::Message)" do
    msg = Siffer::Messages::Register.new("register-source","source-name")
    request = Siffer::Request.new('rack.input' => msg)
    request.message.type.should == "Register"
    request.message.source_id.should == "register-source"
  end
end