require File.join(File.dirname(__FILE__),"spec_helper")

describe Siffer::Container do
  it "should require an environment" do
    lambda {
      container = Siffer::Container.new(:config => {"name" => 'test'})
    }.should raise_error("Environment missing")
  end
  
  it "should require component configuration" do
    lambda { 
      container = Siffer::Container.new
    }.should raise_error("Component Configuration missing")
  end
end

describe Siffer::Container, "options" do
  
  before(:each) do
    @options = {
      :environment => 'test',
      :daemonize => true,
      :pid => 'default_agent.pid',
      :component => 'default_agent',
      :log => 'default_agent.log',
      :config => {
        "agent" => {
          "name" => 'Default Agent',
          "host" => 'localhost',
          "port" => 8200,
          "admin" => 'http://localhost:3000/',
          "servers" => 'http://localhost:4001/'
        }
      }
    }
    @container = Siffer::Container.new(@options)
  end
  
  it "should create component from config options" do
    @container.component.should be_instance_of(Siffer::Agent)
    @options[:config]["server"] = @options[:config].delete("agent")
    @container = Siffer::Container.new(@options)
    @container.component.should be_instance_of(Siffer::Server)
  end
  
  it "should create component that responds to call" do
    @container.component.should respond_to("call")
  end
  
  it "should set name from options" do
    @container.name.should == "Default Agent"
  end
  
  it "should set host from options" do
    @container.host.should == "localhost"
  end
  
  it "should set port from options" do
    @container.port.should == 8200
  end
  
  it "should set daemonization" do
    @container.should be_daemonized
  end
  
  it "should set log file" do
    @container.log.should == "default_agent.log"
  end
  
  it "should set pid file" do
    @container.pid.should == "default_agent.pid"
  end
  
end

describe Siffer::Container, "runtime" do
  
  before(:each) do
    @options = {
      :environment => 'test',
      :daemonize => true,
      :pid => 'default_agent.pid',
      :component => 'default_agent',
      :log => 'default_agent.log',
      :config => {
        "agent" => {
          "name" => 'Default Agent',
          "host" => 'localhost',
          "port" => 8210,
          "admin" => 'http://localhost:3000/',
          "servers" => 'http://localhost:4001/'
        }
      }
    }
    @container = Siffer::Container.new(@options)
  end
  
  it "should create a pid file" do
    @container.send("write_pid_file")
    File.exists?("default_agent.pid").should == true
    File.delete("default_agent.pid") if File.exists?("default_agent.pid")
  end
end