require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Messages

describe Ack do
  before(:each) do
    @msg = Message.new("source")
    @ack = Ack.new("ack-msg", @msg)
  end
  
  it "should have an original message" do
    @ack.original_msg.should be(@msg)
  end
  
  it "should allow an error to be added through options" do
    ack = Ack.new("ack-msg",Message.new("source"),:error => Error.new(3,2))
    ack.read.should match(/SIF_Error/)
    ack.read.should match(/SIF_Category>3<\/SIF_Category>/)
    ack.read.should match(/SIF_Code>2<\/SIF_Code>/)
  end
end