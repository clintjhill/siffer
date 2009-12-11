require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Error do
  
  it "should require error_category" do
    lambda{
      Error.create(:error_code => 0, :error_desc => "test")
    }.should raise_error
  end
  
  it "should require error_code" do
    lambda{
      Error.create(:error_category => 1, :error_desc => "test")
    }.should raise_error
  end
  
  it "should require error_desc" do
    lambda{
      Error.create(:error_code => 0, :error_category => 0)
    }.should raise_error
  end
  
  it "should require valid error_category" do
    lambda{
      Error.create(:error_category => 1000, :error_code => 0, :error_desc => "test")
    }.should raise_error
  end
  
  it "should require valid error_code" do
    lambda{
      Error.create(:error_category => 1, :error_code => 19999, :error_desc => "test")
    }.should raise_error
  end
  
end