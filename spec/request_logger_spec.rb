require File.join(File.dirname(__FILE__),"spec_helper")

describe Siffer::RequestLogger do
  msg = <<"MSG"
<SIF_Message>
  <SIF_SystemControl><SIF_Ping /></SIF_SystemControl>
</SIF_Message>
MSG
  it "should log requests" do
    log = []
    app = Rack::Builder.new do
      use Siffer::RequestLogger, log
      run Siffer::Server.new("admin" => "none")
    end
    res = Rack::MockRequest.new(app).post("/", :input => msg)
    log.size.should == 1
  end
end