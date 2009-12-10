require File.join(File.dirname(__FILE__),"..", "spec_helper")

include Siffer::Messages

describe Header do
  
  it "should require a source, msg_id, timestamp" do
    lambda{ Header.create }.should raise_error
  end
  
  it "should build UUID for msg_id by default" do
    head = Header.create(:source => 'test')
    head.msg_id.should_not be_nil
  end
  
  it "should make timestamp by default" do
    head = Header.create(:source => 'test')
    head.timestamp.should_not be_nil
  end
  
  it "should allow creation from block" do
    head = Header.create do |h|
      h.source_id = "Created by Block"
      h.timestamp = DateTime.parse("11/20/1975")
    end
    head.source_id.should == "Created by Block"
    head.timestamp.year.should == 1975
  end
  
  it "should pass options into Security on create" do
    head = Header.create(:source => "test options", :authentication => 4, :encryption => 3)
    head.security.secure_channel.authentication_level.should == 4
    head.security.secure_channel.encryption_level.should == 3
  end
  
end
