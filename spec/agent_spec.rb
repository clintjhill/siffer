require File.join(File.dirname(__FILE__), "spec_helper")
require 'webrick'

describe Siffer::Agent do
  it "should instantiate with default host, port, name" do
    agent = Siffer::Agent.new("servers" => 'none', "admin" => 'none')
    agent.host.should == "localhost"
    agent.port.should == 8300
    agent.name.should == "Default Agent"
  end
  
  it "should allow defaults to be overriden" do
    agent = Siffer::Agent.new("admin" => 'none',
                              "servers" => 'none', 
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
      }.should raise_error("Server URL(s) required")
  end
  
  it "should require an admin URL" do
    lambda {
      agent = Siffer::Agent.new("servers" => "none")
    }.should raise_error("Administration URL required")
  end
  
  it "should respond to uri" do
    agent = Siffer::Agent.new("admin" => 'none', "servers" => 'none')
    agent.uri.should == "http://localhost:8300"
  end
  
  it "should register with server(s)" do
    fake_server = lambda { |env| [200,{},env["rack.input"].read] }
    server = WEBrick::HTTPServer.new(:Host => '0.0.0.0',:Port => 9203)
    server.mount "/", Rack::Handler::WEBrick, fake_server
    Thread.new { server.start }
    trap(:INT) { server.shutdown }
    agent = Siffer::Agent.new("admin" => 'none', "servers" => 'http://localhost:9203/')
    agent.wake_up
    agent.should be_registered
    server.shutdown
  end
  
  it "should be unregistered by default" do
    agent = Siffer::Agent.new("admin" => 'none', "servers" => 'none')
    agent.should_not be_registered
  end
  
end