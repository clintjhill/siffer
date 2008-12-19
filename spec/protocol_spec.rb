require File.join(File.dirname(__FILE__), "spec_helper")

[Siffer::Server, Siffer::Agent].each do |component|
  
  describe component, "Protocol - /unknown_path" do
    it "should raise unknown path exception for bad paths" do
      lambda {
        Rack::MockRequest.new(component.new).get("/bad_path")
      }.should raise_error("Unknown path")
    end
  end
  
  describe component, "Accepted Paths" do
    it "should only allow POST method" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        lambda {
          Rack::MockRequest.new(component.new).get(path)
        }.should raise_error("Only POST method allowed")
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
    it "should answer to /ping" do
      @res = Rack::MockRequest.new(component.new).post("/ping")
      @res.should be_ok
    end
  end
  
  describe component, "Protocol - /status" do
    it "should answer to /status" do
      @res = Rack::MockRequest.new(component.new).post("/status")
      @res.should be_ok
    end
  end
end