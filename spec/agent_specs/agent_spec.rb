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
  
  it "should display agent name in title" do
    get "/"
    last_response.body.should match(/<title>Siffer Agent - Not Named<\/title>/)
  end
  
  it "should allow setting of Agent Name" do
    Siffer::Agent.set :agent_name, "Test Agent"
    get "/"
    last_response.body.should match(/<title>Siffer Agent - Test Agent<\/title>/)
  end
  
end