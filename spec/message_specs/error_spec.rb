require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Error do
  
  it "should require category" do
    lambda{
      Error.create(:code => 0, :description => "test")
    }.should raise_error
  end
  
  it "should require code" do
    lambda{
      Error.create(:category => 1, :description => "test")
    }.should raise_error
  end
  
  it "should require description" do
    lambda{
      Error.create(:code => 0, :category => 0)
    }.should raise_error
  end
  
  it "should require valid category" do
    lambda{
      Error.create(:category => 1000, :code => 0, :description => "test")
    }.should raise_error
  end
  
  it "should require valid code" do
    lambda{
      Error.create(:category => 1, :code => 1, :description => "test")
    }.should raise_error
  end
  
end