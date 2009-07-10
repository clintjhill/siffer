require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Models

describe Address do
  it "should require street" do
    Address.should require(:street)
  end
end

describe Street do
  it "should require line 1" do
    Street.should require(:line_1)
  end
end
    
