require File.join(File.dirname(__FILE__),"spec_helper")

describe Siffer::RequestLogger do
  msg = "<SIF_Message><SIF_SystemControl><SIF_Ping /><SIF_Header><SIF_SourceId>Test Source</SIF_SourceId></SIF_Header></SIF_SystemControl></SIF_Message>"
  
  before(:each) do
    @@log = []
    @app = Rack::Builder.new do
      use Siffer::RequestLogger, @@log
      run Siffer::Server.new("admin" => "none")
    end  
  end
  
  it "should log requests" do
    res = Rack::MockRequest.new(@app).post("/", :input => msg)
    @@log.size.should == 1
  end
  
  it "should identify SIF_Source in log message" do
    res = Rack::MockRequest.new(@app).post("/", :input => msg)
    @@log[0].should match(/Ping request made by Test Source/)
  end
  
  it "should ignore request bodies that are not SIF based" do
    res = Rack::MockRequest.new(@app).get("/")
    @@log[0].should match(/Unknown request made by Unknown Source/)
  end
end