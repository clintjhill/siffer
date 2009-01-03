require File.join(File.dirname(__FILE__),"..","spec_helper")

describe Siffer::Messages::Error do
  
  it "should properly match the SIF Spec (random crap test)" do
    error = Siffer::Messages::Error.new(8,3)
    error.category.should == "Request and Response"
    error.code.should == "Invalid object"
    
    error = Siffer::Messages::Error.new(5,2)
    error.category.should == "Registration"
    error.code.should == "The SIF_SourceId is invalid"
  end
  
  it "should output xml through read method" do
    error = Siffer::Messages::Error.new(4,8, "Added Extended")
    error.read.should match(/SIF_Error/)
    error.read.should match(/SIF_Category>4<\/SIF_Category/)
    error.read.should match(/SIF_Code>8<\/SIF_Code/)
    error.read.should match(/SIF_Desc>#{error.code}<\/SIF_Desc/)
    error.read.should match(/SIF_ExtendedDesc>Added Extended<\/SIF_Extended/)
  end
  
end