require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Application do

  it "should require Vendor" do
    Application.should require(:vendor)
  end
  
  it "should require Product" do
    Application.should require(:product)
  end
  
  it "should require Version" do
    Application.should require(:version)
  end
  
end

describe Register do
  
  it "should require name" do
    Register.should require(:name)
  end
  
  it "should require version" do
    Register.should require(:version)
  end
  
  it "should require MaxBufferSize" do
    Register.should require(:max_buffer_size)
  end
  
  it "should require Mode" do
    Register.should require(:mode)
  end
  
  it "should conditionally require Protocol" do
    Register.should conditionally_require(:protocol, :mode => "Push")
  end
  
end