require File.join(File.dirname(__FILE__), "spec_helper")

describe Siffer::Agent do
  it "should instantiate with default host, port, name" do
    agent = Siffer::Agent.new
    agent.host.should == "localhost"
    agent.port.should == 8300
    agent.name.should == "Default Agent"
  end
end