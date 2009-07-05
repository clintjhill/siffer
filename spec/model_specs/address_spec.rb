require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Models
describe Address do
  it "should require street" do
    lambda{Address.new}.should raise_error(MandatoryError, /Street/)
  end
end

describe Siffer::Models::Street do
  it "should require line 1" do
    lambda{Street.new}.should raise_error(MandatoryError, /Line 1/)
  end
end
    
