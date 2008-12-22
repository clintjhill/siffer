require File.join(File.dirname(__FILE__), "spec_helper")

[Siffer::Server, Siffer::Agent].each do |component|
  
  describe component, "Protocol - /unknown_path" do
    it "should return 404" do
      res = Rack::MockRequest.new(component.new).post("/bad_path")
      res.should be_not_found
    end
  end
  
  describe component, "Accepted Paths" do
    it "should only allow POST method" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        res = Rack::MockRequest.new(component.new).get(path)
        res.should be_client_error
      end
    end
  end

  describe component, "Protocol - /" do
    it "should respond to /" do
      @res = Rack::MockRequest.new(component.new).post("/")
      @res.should be_ok
    end
  end
  
  describe component, "Protocol - /ping" do
    it "should respond to /ping" do
      @res = Rack::MockRequest.new(component.new).post("/ping")
      @res.should be_ok
    end
  end
  
  describe component, "Protocol - /status" do
    it "should respond to /status" do
      @res = Rack::MockRequest.new(component.new).post("/status")
      @res.should be_ok
    end
  end
end