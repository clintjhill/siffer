require File.join(File.dirname(__FILE__), "spec_helper")

# setup messages to use for mock requests 
ping = "<SIF_Message><SIF_SystemControl><SIF_Ping /></SIF_SystemControl></SIF_Message>"
status = "<SIF_Message><SIF_SystemControl><SIF_Status /></SIF_SystemControl></SIF_Message>"
register = "<SIF_Message><SIF_Register /></SIF_Message>"

describe Siffer::Request do  
  it "should provide access to the body as a SIF_Message (Siffer::Message)" do
    msg = Siffer::Messages::Register.new("register-source","source-name")
    request = Siffer::Request.new('rack.input' => msg)
    request.message.type.should == "Register"
    request.message.source_id.should == "register-source"
  end
  
  it "should identify message by predicate through body" do
    Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
      unless name == :root
        req = Siffer::Request.new("rack.input" => eval(name.to_s))
        req.should eval("be_#{name.to_s}")
      end
    end
  end
   
end