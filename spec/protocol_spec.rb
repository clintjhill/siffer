require File.join(File.dirname(__FILE__), "spec_helper")

[Siffer::Server, Siffer::Agent].each do |component|
  
  # Stage the component a little bit:
  #    Agents require Servers
  #    Both require central-admin 
  component = component.new("admin" => 'none', "servers" => '')
  
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
    
    it "should be identified by predicate" do
      ping = <<"PING"
<SIF_Message>
  <SIF_SystemControl><SIF_Ping /></SIF_SystemControl>
</SIF_Message>
PING
      status = <<"STATUS"
<SIF_Message>
  <SIF_SystemControl><SIF_Status /></SIF_SystemControl>
</SIF_Message>
STATUS
      register = <<"REGISTER"
<SIF_Message>
  <SIF_Register />
</SIF_Message>
REGISTER
      Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
        unless name == :root
          component.call({"rack.input" => eval(name.to_s), "PATH_INFO" => path})
          component.should eval("be_#{name.to_s}")
        end
      end
    end
  end
end