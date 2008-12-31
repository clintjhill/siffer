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
end