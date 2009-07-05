require File.join(File.dirname(__FILE__), "spec_helper")

describe Siffer::Server do  
  it "should instantiate with default host, port, name, min_buffer" do
    server = Siffer::Server.new("admin" => 'none')
    server.host.should == "localhost"
    server.port.should == 8300
    server.name.should == "Default Server"
    server.min_buffer.should == 1024
  end
  
  it "should allow defaults to be overriden" do
    server = Siffer::Server.new("admin" => 'none',
                                "name" => "name", 
                                "host" => "test", 
                                "port" => 222,
                                "min_buffer" => 2048)
    server.host.should == "test"
    server.port.should == 222
    server.name.should == "name"
    server.min_buffer.should == 2048
  end
  
  it "should require an admin URL" do
    lambda {
      server = Siffer::Server.new
    }.should raise_error("Administration URL required")
  end
  
  it "should fail agent registration detection if admin unreachable" do
    server = Siffer::Server.new("admin" => 'none')
    server.registered?("Default Agent").should be_false
  end
  
end