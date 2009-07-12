module Siffer
  module Messages

    NOTIFICATION_TYPES = {
      :standard => "Standard",
      :none => "None"
    }
    
    # Sent to detect if a ZIS or push-mode agent is ready to receive and process messages.
    #@see SystemControl
    class Ping < SifXml; end

    # Allows an agent to notify a ZIS or a ZIS to notify a push-mode agent that it must not send any more messages to the sender of the SIF_Sleep.
    #@see SystemControl
    class Sleep < SifXml; end

    # This will signal the receiver that the sender is now able to process messages.
    #@see SystemControl
    class Wakeup < SifXml; end
    
    # This message tells the ZIS to return the first available message to the agent, subject to Selective Message Blocking.
    #@see SystemControl
    class GetMessage < SifXml; end
    
    # This message tells the ZIS to return the current SIF_ZoneStatus in a SIF_Ack.
    #@see SystemControl
    class GetZoneStatus < SifXml; end
    
    # This message tells the ZIS to return the Agent's ACL permissions in a SIF_Ack.
    #@see SystemControl
    class GetAgentACL < SifXml; end
    
    # The list of SIF_Requests to cancel
    #@see CancelRequests
    class RequestMsgIds < SifXml
      element :request_msg_id, :type => :mandatory
    end
    
    # Asks a receiver (ZIS or Push-Mode Agent) to cancel the specified SIF_Requests, pending or in process
    #@see SystemControl
    class CancelRequests < SifXml 
      element :notification_type, :type => :mandatory
      element :request_msg_ids, :type => :mandatory
    end
    
    
    # Message designed to control the flow of data between an agent and ZIS or vice-versa.
    class SystemControl < Message
      element :system_control_data, :type => :mandatory
      
      class << self
        
        # Returns a SIF_Ping
        def ping(source)
          SystemControl.new(:source_id => source, :system_control_data => Ping.new)
        end
        
        # Returns a SIF_Sleep
        def sleep(source)
          SystemControl.new(:source_id => source, :system_control_data => Sleep.new)
        end
        
        # Returns a SIF_Wakeup
        def wake_up(source)
          SystemControl.new(:source_id => source, :system_control_data => Wakeup.new)
        end
        
        # Returns a SIF_GetMessage
        def get_message(source)
          SystemControl.new(:source_id => source, :system_control_data => GetMessage.new)
        end
        
        # Returns a SIF_GetZoneStatus
        def get_zone_status(source)
          SystemControl.new(:source_id => source, :system_control_data => GetZoneStatus.new)
        end
        
        # Returns a SIF_GetAgentACL
        def get_agent_acl(source)
          SystemControl.new(:source_id => source, :system_control_data => GetAgentACL.new)
        end
        
        # Returns a SIF_CancelRequest
        def cancel_requests(source, notification, *ids)
          cancel = CancelRequests.new(
                  :notification_type => notification, 
                  :request_msg_ids => RequestMsgIds.new(:request_msg_id => ids))
          SystemControl.new(:source_id => source, :system_control_data => cancel)
        end
      end
    end
    
  end
end