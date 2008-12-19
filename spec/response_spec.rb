require File.join(File.dirname(__FILE__),"spec_helper")

describe Siffer::Response do
  it "should default content-type to application/xml" do
    response = Siffer::Response.new()
    response.content_type.should == Siffer::Messaging::MIME_TYPES["appxml"]
  end
end