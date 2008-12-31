require File.join(File.dirname(__FILE__), "spec_helper")

describe "Siffer Command Line" do
  
  before(:each) do
    @options = eval `./bin/siffer start spec/default_agent -e test -d`
  end
  
  it "should specify config" do
    @options.keys.should include(:config)
    config = @options[:config]
    config.keys.should include("agent")
    config["agent"].keys.should include("host")
    config["agent"].keys.should include("port")
    config["agent"].keys.should include("name")
  end
  
  it "should specify component" do
    @options[:component].should == "spec/default_agent"
  end
  
  it "should specify log directory" do
    cwd = File.expand_path(File.dirname(__FILE__))
    @options[:log].should == File.join(cwd,"default_agent.log") 
  end
  
  it "should specify an environment" do
    @options[:environment].should == "test"
  end
  
  it "should specify daemonization" do
    @options[:daemonize].should == true
  end
  
  it "should specify pid" do
    cwd = File.expand_path(File.dirname(__FILE__))
    @options[:pid].should == File.join(cwd,"default_agent.pid")
  end
  
end