require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Provide do
  
  it "should require an object" do
    Provide.should require(:object)
  end
  
end

describe UnProvide do
  
  it "should require an object" do
    UnProvide.should require(:object)
  end
  
end
