require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Ack do
  
  it "should require original msg id" do
    lambda {
      Ack.create(:source => "testing requires")
    }.should raise_error
  end
  
  it "should require original source id" do
    lambda {
      Ack.create(:source => "test", :original_msg_id => "test")
    }.should raise_error
  end
  
  it "should automatically build header" do
    ack = Ack.create(:source => "testing ack", :original_source_id => "test", :original_msg_id => "test")
    ack.header.should_not be_nil
    ack.header.source_id.should == "testing ack"
  end
  
  it "should allow static status creation" do
    ack = Ack.status(:status_code => 1, :source => "testing status", :original_source_id => "test", :original_msg_id => "test")
    ack.status.code.should == 1
    ack.status.description.should == STATUS_CODE[1]
  end
  
end