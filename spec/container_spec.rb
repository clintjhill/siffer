require File.join(File.dirname(__FILE__),"spec_helper")

#### 
## TODO: Make a better spec jeez
####
describe Siffer::Container do
  it "should require component configuration" do
    lambda { 
      container = Siffer::Container.new
    }.should raise_error("Component Configuration missing")
  end
  
  it "should parse component info from options" do
    container = Siffer::Container.new(:env => 'development', :config => 
                              {"agent" => 
                                {:name => 'Default', 
                                  :port => 2828, 
                                  :host => 'localhost'}})
                              
    container.component.should == "agent"
    container.name.should == "Default"
    container.host.should == "localhost"
    container.port.should == 2828
  end
  
  it "should provide default to Mongrel server" do
    container = Siffer::Container.new(:config => {"agent" => {}})
    container.server.should == Rack::Handler::Mongrel
  end
  
end