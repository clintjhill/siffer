require File.join(File.dirname(__FILE__),"spec_helper")

# Registration is best tested through the Siffer::Server component

describe Siffer::Registration do
  
  before(:each) do
    @server = Siffer::Server.new("admin" => "none")
  end
  
  it "should determine agent registration" do
    @server.registered?("Default Agent").should be_false
    @server.agents["Default Agent"] = "http://localhost"
    @server.registered?("Default Agent").should be_true
  end
  
  it "should return not registered message for non-registered agents" do
    msg = Siffer::Messages::Message.new("Default Agent")
    msg.content do |xml|
      xml.SIF_Ping
    end
    res = response_to(msg)
    res.body.should match(/SIF_Category>4/)
    res.body.should match(/SIF_Code>9/)
  end
  
  it "should return ACL for successful registration" do
    msg = Siffer::Messages::Register.new("Default Agent", "Default Agent")
    res = response_to(msg)
    res.body.should match(/SIF_Ack/)
    res.body.should match(/SIF_Status/)
  end
end