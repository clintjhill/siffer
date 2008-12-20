require File.join(File.dirname(__FILE__),"spec_helper")
require 'webrick'

Thread.abort_on_exception = true

describe Siffer::Response do
  it "should default content-type to application/xml" do
    response = Siffer::Response.new()
    response.content_type.should == Siffer::Messaging::MIME_TYPES["appxml"]
  end
  
  it "should receive response from url,data" do
    fake_app = lambda { |env| [200,{},env["rack.input"].read] }
    server = WEBrick::HTTPServer.new(:Host => '0.0.0.0',:Port => 9202)
    server.mount "/", Rack::Handler::WEBrick, fake_app
    Thread.new { server.start }
    trap(:INT) { server.shutdown }
    response = Siffer::Response.from("http://localhost:9202/","Hello World")
    response.should be_successful
    response.body.each { |line| line.should == "Hello World" }
    server.shutdown
  end
end