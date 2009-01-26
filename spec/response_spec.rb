require File.join(File.dirname(__FILE__),"spec_helper")
require 'webrick'

Thread.abort_on_exception = true

describe Siffer::Response do
  it "should default content-type to application/xml with UTF-8" do
    response = Siffer::Response.new()
    response.content_type.should == Siffer::Messaging::MIME_TYPES["appxmlencoded"]
  end
  
  it "should receive response from url,data" do
    with_fake_server do |url|
      response = Siffer::Response.from(url,"Hello World")
      response.should be_successful
      response.body.each { |line| line.should == "Hello World" }  
    end
  end
  
  it "should return 500 for bad url" do
    response = Siffer::Response.from("http://localhost:9999","Hello World")
    response.should be_server_error
  end
end