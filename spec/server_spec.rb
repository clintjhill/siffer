require File.join(File.dirname(__FILE__), "spec_helper")

describe Siffer::Server do  
  it "should instantiate with default host, port, name" do
    server = Siffer::Server.new("admin" => 'none')
    server.host.should == "localhost"
    server.port.should == 8300
    server.name.should == "Default Server"
  end
  
  it "should allow defaults to be overriden" do
    server = Siffer::Server.new("admin" => 'none',
                                "name" => "name", 
                                "host" => "test", 
                                "port" => 222)
    server.host.should == "test"
    server.port.should == 222
    server.name.should == "name"
  end
  
  it "should require an admin URL" do
    lambda {
      server = Siffer::Server.new
    }.should raise_error("Administration URL required")
  end
  
  it "should respond to uri" do
    server = Siffer::Server.new("admin" => 'none')
    server.uri.should == "http://localhost:8300"
  end
  
end