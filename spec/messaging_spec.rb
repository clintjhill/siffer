require File.join(File.dirname(__FILE__),"spec_helper")

[Siffer::Server, Siffer::Agent].each do |component|
  
  # Stage the component a little bit:
  #    Agents require Servers
  #    Both require central-admin 
  component = component.new("servers" => '')
  
  describe component, "Messaging - responses" do
    it "should all be SIF_Ack body" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        @response = Rack::MockRequest.new(component).post(path)
        @response.body.should match(/<SIF_Ack>/)
      end
    end  
  end
    
  describe component, "Messaging - content-type" do
    it "should always respond with application/xml" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        @res = Rack::MockRequest.new(component).post(path)
        @res.content_type.should == Siffer::Messaging::MIME_TYPES["appxml"]
      end
    end
    
    it "should only receive application/xml" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        res = Rack::MockRequest.new(component).post(path, "CONTENT_TYPE" => "x")
        res.should be_client_error
      end
    end
  end

end