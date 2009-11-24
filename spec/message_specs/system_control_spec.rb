require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Messages

describe SystemControl do

  it "should require system control data" do
    SystemControl.should require(:system_control_data)
  end
  
  it "should provide ping message" do
    SystemControl.ping("Test").acdc.should match(/<SIF_Ping\/>/)
  end
  
  it "should provide sleep message" do
    SystemControl.sleep("Test").acdc.should match(/<SIF_Sleep\/>/)
  end
  
  it "should provide wake up message" do
    SystemControl.wake_up("Test").acdc.should match(/<SIF_Wakeup\/>/)
  end
  
  it "should provide get message message" do
    SystemControl.get_message("Test").acdc.should match(/<SIF_GetMessage\/>/)
  end
  
  it "should provide get zone status message" do
    SystemControl.get_zone_status("Test").acdc.should match(/<SIF_GetZoneStatus\/>/)
  end
  
  it "should provide get agent ACL message" do
    SystemControl.get_agent_acl("Test").acdc.should match(/<SIF_GetAgentACL\/>/)
  end
  
  it "should provide cancel requests message" do
    SystemControl.cancel_requests("Test", NOTIFICATION_TYPES[:standard], "111111","2222222","333333").acdc.should match(/<SIF_CancelRequests>/)
  end
  
end
