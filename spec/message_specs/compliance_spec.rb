# require File.join(File.dirname(__FILE__),"..","spec_helper")
# 
# include Siffer::Messages
# 
# describe Siffer::Messages do
#   
#   it "should have compliant Ack" do
#     msg = Ack.new(:header => "test ack", 
#           :original_source_id => "original", 
#           :original_msg_id => "1"*32, 
#           :status => Status.new(:code => 0, 
#                                 :data => Request.new(:header => "test request", 
#                                             :version => "2.*", 
#                                             :max_buffer_size => 1048576, 
#                                             :query => Query.new(:query_object => QueryObject.new(:object_name => "LibraryPatronStatus"),
#                                                                 :condition_group => ConditionGroup.new(:conditions => Condition.new(:element => "StudentTest", :operator => "EQ", :value => "A"))))))
#     msg.acdc.should be_compliant
# 
#     msg = Ack.new(
#                 :header => "test ack",
#                 :original_source_id => "original",
#                 :original_msg_id => "1"*32,
#                 :error => Error.new(:category => 1, :code => 1, :desc => XML_VALIDATION_ERROR[1]))
#     msg.acdc.should be_compliant
#   end
#     
#   it "should have compliant System Control Cancel Request" do
#     msg = SystemControl.cancel_requests("test cancel", NOTIFICATION_TYPES[:none], "1"*32,"2"*32,"3"*32)
#     msg.acdc.should be_compliant
#   end
#   
#   it "should have compliant System Control Ping" do
#     SystemControl.ping("Source Ping").acdc.should be_compliant
#   end
#   
# end