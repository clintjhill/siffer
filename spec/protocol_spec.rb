require File.join(File.dirname(__FILE__), "spec_helper")

[Siffer::Server, Siffer::Agent].each do |component|
  
  # Stage the component a little bit:
  #    Agents require Servers
  #    Both require central-admin 
  component = component.new("admin" => 'none', "servers" => '')
  # setup messages to use for mock requests 
  ping = "<SIF_Message><SIF_SystemControl><SIF_Ping /></SIF_SystemControl></SIF_Message>"
  status = "<SIF_Message><SIF_SystemControl><SIF_Status /></SIF_SystemControl></SIF_Message>"
  register = "<SIF_Message><SIF_Register /></SIF_Message>"

  describe component, "Protocol - /unknown_path" do
    it "should return 404" do
      res = Rack::MockRequest.new(component).post("/bad_path")
      res.should be_not_found
    end
  end
  
  describe component, "Protocol - Accepted Paths" do
    it "should only allow POST method" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        res = Rack::MockRequest.new(component).get(path)
        res.should be_client_error
      end
    end
    
    it "should be identified by predicate through body" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        unless name == :root
          component.call({"rack.input" => eval(name.to_s)})
          component.should eval("be_#{name.to_s}")
        end
      end
    end
    
    it "should be identified by predicate through path-info" do
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        unless name == :root
          component.call({
            "rack.input" => "<SIF_Message><SIF_#{name.to_s} /></SIF_Message>", 
            "PATH_INFO" => path})
          component.should eval("be_#{name.to_s}")
        end
      end
    end
  end
end