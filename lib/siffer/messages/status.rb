module Siffer
  module Messages
    
    class Status < AcDc::Body
      tag_name "SIF_Status"
      element :code, Integer, :tag => "SIF_Code"
      element :description, String, :tag => "SIF_Desc"
      # element :data ====== can be Message, AgentACL or ZoneStatus
      
      def self.create(options = {}, &block)
        status = Status.new
        status.code = options[:status_code] || 0
        status.description = STATUS_CODE[status.code]
        yield status if block_given?
        raise "Status Code not valid" unless STATUS_CODE.keys.include?(status.code)
        status
      end
      
    end
    
    STATUS_CODE = {
      0	=> "Success (ZIS ONLY). SIF_Status/SIF_Data may contain additional data.",
      1	=> "Immediate SIF_Ack (AGENT ONLY). Message is persisted or processing is complete. Discard the referenced message.",
      2	=> "Intermediate SIF_Ack (AGENT ONLY). Only valid in response to SIF_Event delivery. Invokes Selective Message Blocking. The event referenced must still be persisted, and no other events must be delivered, until the agent sends a \"Final\" SIF_Ack at a later time.",
      3	=> "Final SIF_Ack (AGENT ONLY). Sent (a SIF_Ack with this value is never returned by an agent in response to a delivered message) by an agent to the ZIS to end Selective Message Blocking. Discard the referenced event and allow for delivery of other events.",
      7	=> "Already have a message with this SIF_MsgId from you.",
      8	=> "Receiver is sleeping.",
      9	=> "No messages available. This is returned when an agent is trying to pull messages from a ZIS and there are no messages available."
    }
    
  end
end