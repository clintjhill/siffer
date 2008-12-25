require File.join(File.dirname(__FILE__), "spec_helper")

describe Siffer::Agent do
  it "should instantiate with default host, port, name" do
    agent = Siffer::Agent.new("servers" => 'none')
    agent.host.should == "localhost"
    agent.port.should == 8300
    agent.name.should == "Default Agent"
  end
  
  it "should allow defaults to be overriden" do
    agent = Siffer::Agent.new("servers" => 'none', 
                              "name" => "name",
                              "host" => "test",
                              "port" => 222)
    agent.host.should == "test"
    agent.name.should == "name"
    agent.port.should == 222
  end
  
  it "should require a server url to register with" do
    lambda {
      agent = Siffer::Agent.new 
      }.should raise_error "Server URL(s) required"
  end
  
  it "should respond to uri" do
    agent = Siffer::Agent.new("servers" => 'none')
    agent.uri.should == "http://localhost:8300"
  end
end