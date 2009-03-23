require File.join(File.dirname(__FILE__), "spec_helper")

describe Siffer::Administration::Site do

  before(:each) do
    @admin_site = Rack::MockRequest.new(Siffer::Administration::Site.new)
  end
  
  it "should have a home page" do
    @admin_site.get("/").status.should == 200
  end
  
  it "should have a servers page" do
    @admin_site.get("/servers").status.should == 200
  end
  
end