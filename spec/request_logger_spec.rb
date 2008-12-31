require File.join(File.dirname(__FILE__),"spec_helper")

describe Siffer::RequestLogger do
  it "should log requests" do
    log = []
    res = Rack::MockRequest.new(
                Siffer::RequestLogger.new(
                  Siffer::Server.new("admin" => 'none'),
                  log
                )).post("/", 
                        :input => "<SIF_Message><SIF_Ping /></SIF_Message>")
    log.size.should == 1
  end
end