require File.join(File.dirname(__FILE__),"spec_helper")

[Siffer::Server, Siffer::Agent].each do |component|
  
  describe component, "Messaging - responses" do
    it "should all be SIF_Ack" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        @response = Rack::MockRequest.new(Siffer::Server.new).post(path)
        @response.body.should match(/<SIF_Ack>/)
      end
    end  
  end
  
  describe component, "Messaging - headers" do
    it "should return original source from headers" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        @res = Rack::MockRequest.new(Siffer::Server.new).post(path,
                                      "HTTP_SOURCE" => "sif_ack_source")
        @res.body.should match(/SIF_OriginalSourceId>sif_ack_source/)
      end
    end
    
    it "should use HTTP_HOST if present" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        @res = Rack::MockRequest.new(Siffer::Server.new).post(path,
                                      "HTTP_HOST" => "test_host")
        @res.body.should match(
                    /<SIF_OriginalSourceId>test_host<\/SIF_OriginalSourceId>/)
      end
    end
    
    it "should set :Browser if HTTP_USER_AGENT present" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        @res = Rack::MockRequest.new(Siffer::Server.new).post(path,
                                      "HTTP_USER_AGENT" => "test_host")
        @res.body.should match(/\w*:\d*:Browser/)
      end
    end
  end
    
  describe component, "Messaging - content-type" do
    it "should always send application/xml" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        @res = Rack::MockRequest.new(component.new).post(path)
        @res.content_type.should == Siffer::Messaging::MIME_TYPES["appxml"]
      end
    end
    
    it "should only receive application/xml" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        lambda {
          Rack::MockRequest.new(component.new).post(path, "CONTENT_TYPE" => "x")
        }.should raise_error("Content Type is not accepted")
      end
    end
  end

end