require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Status do
  
  it "should require code" do
    Status.should require(:code)
  end

end

describe Error do

  it "should require category" do
    Error.should require(:category)
  end
  
  it "should require code" do
    Error.should require(:code)
  end
  
  it "should require desc" do
    Error.should require(:desc)
  end
  
end

describe Ack do
  
  it "should require original source id" do
    Ack.should require(:original_source_id)
  end
  
  it "should require original message id" do
    Ack.should require(:original_msg_id)
  end
  
  it "should must have :error, :status" do
    Ack.should must_have(:status, :error)
  end
  
end