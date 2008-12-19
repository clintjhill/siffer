require File.join(File.dirname(__FILE__), "spec_helper")

describe Siffer::Request do
  it "should respond to ping?" do
    request = Siffer::Request.new({"PATH_INFO" => "/ping"})
    request.should respond_to("ping?")
    request.should be_ping
  end
  
  it "should respond to status?" do
    request = Siffer::Request.new({"PATH_INFO" => "/status"})
    request.should respond_to("status?")
    request.should be_status
  end
  
  it "should default content-type to application/xml;charset=utf-8" do
    request = Siffer::Request.new({})
    request.content_type.should == Siffer::Messaging::MIME_TYPES["appxml"]
  end
end