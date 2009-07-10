require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Status do
  
  it "should require code" do
    Status.should require(:code)
  end
  
  it "should provide success helper" do
    @success = Status.success
    @success.code.should eql(0)
    @success.desc.should eql(STATUS_CODE[0])
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
  
  it "should be nested in message" do
    @ack = Ack.new(:source_id => "Test Ack", :original_source_id => "11111", :original_msg_id => "22222", :status => "good")
    @ack.should match(/^<SIF_Message/)
    @ack.should match(/<\/SIF_Message>$/)
  end
  
end