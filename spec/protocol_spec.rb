require File.join(File.dirname(__FILE__), "spec_helper")

[Siffer::Server, Siffer::Agent].each do |component|
  
  # Stage the component a little bit:
  #    Agents require Servers
  #    Both require central-admin 
  component = component.new("servers" => '')
  
  describe component, "Protocol - /unknown_path" do
    it "should return 404" do
      res = Rack::MockRequest.new(component).post("/bad_path")
      res.should be_not_found
    end
  end
  
  describe component, "Accepted Paths" do
    it "should only allow POST method" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        res = Rack::MockRequest.new(component).get(path)
        res.should be_client_error
      end
    end
  end

  describe component, "Protocol - /" do
    it "should respond to /" do
      @res = Rack::MockRequest.new(component).post("/")
      @res.should be_ok
    end
  end
  
  describe component, "Protocol - /ping" do
    it "should respond to /ping" do
      @res = Rack::MockRequest.new(component).post("/ping")
      @res.should be_ok
    end
  end
  
  describe component, "Protocol - /status" do
    it "should respond to /status" do
      @res = Rack::MockRequest.new(component).post("/status")
      @res.should be_ok
    end
  end
end