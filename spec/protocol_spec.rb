require File.join(File.dirname(__FILE__), "spec_helper")

[Siffer::Server, Siffer::Agent].each do |component|
  
  # Stage the component a little bit:
  #    Agents require Servers
  #    Both require central-admin 
  component = component.new("admin" => 'none', "server" => '')
  
  describe component, "Protocol - /unknown_path" do
    it "should return 404" do
      res = Rack::MockRequest.new(component).post("/bad_path")
      res.should be_not_found
    end
  end
  
  describe component, "Protocol - Accepted Paths except Root URL" do
    it "should only allow POST method" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        if(path != "/")
          res = Rack::MockRequest.new(component).get(path)
          res.should be_client_error
        end
      end
    end
  end
  
  describe component, "Protocol - Root URL on GET" do
    it "should display component info" do
      res = Rack::MockRequest.new(component).get("/")
      res.should be_ok
      res.body.should match(/<h1>Siffer Endpoint<\/h1>/)
    end
  end
  
  describe component, "Protocol - URI" do
    
    it "should respond to uri" do
      component.uri.should == "http://localhost:8300"
    end

    it "should respond to full url in uri" do
      component = component.class.new("admin" => "none", 
                                      "server" => "", 
                                      "host" => "http://localhost")
      component.uri.should == "http://localhost:8300"
    end
  end
  
end