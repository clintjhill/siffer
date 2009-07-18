require File.join(File.dirname(__FILE__),"..","spec_helper")

describe Siffer::Agent do
  include Rack::Test::Methods

  def app
    Siffer::Agent.new
  end
  
  it "should respond to index (default)" do
    get "/"
    last_response.should be_ok
  end
  
  it "should default agent name to Not Named" do
    Siffer::Agent.agent_name.should eql("Not Named")
  end
  
  it "should default ZIS URL to Not Set" do
    Siffer::Agent.zis_url.should eql("Not Set")
  end
  
  it "should set title to agent name" do
    Siffer::Agent.set :agent_name, "Test Agent"
    get "/"
    last_response.body.should match(/<title>Siffer Agent - Test Agent<\/title>/)
  end
  
  it "should show registration dialog if not registered" do
    get "/"
    last_response.body.should match(/div id='register'>/)
  end
  
  it "should respond to register" do
    post "/register"
    last_response.should be_ok
  end
  
  # it "should redirect to index after successful register" do
  #     post "/register", {:zis_url => "tester"}
  #     # need to mock #registered? here
  #     last_response.should be_redirect
  #   end
  #   
end