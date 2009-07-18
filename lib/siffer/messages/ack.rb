module Siffer
  module Messages
    
    #@see Status
    class Data < SifXml
      element :data, :type => :mandatory
      def initialize(vals = {})
        klass = vals[:message].keys.first.to_s.capitalize.constantize
        vals[:data] = klass.new(vals[:message][vals[:message].keys.first])
        super(vals)
      end
      
    end
    # Element containing Status information
    #@see Ack
    class Status < SifXml
      element :code, :type => :mandatory
      element :desc
      element :data
      
      def initialize(vals = {})
        vals = vals[:status] if vals.has_key?(:status)
        if vals.has_key?(:data) and vals[:data].is_a?(Hash)
          vals[:data] = Data.new(vals[:data])
        end
        super(vals)
      end
    end
    
    # Element containing Error information
    #@see Ack
    class Error < SifXml
      element :category, :type => :mandatory
      element :code, :type => :mandatory
      element :desc, :type => :mandatory
      element :extended_des
    end
    
    # Message used as an acknowledgement for infrastructure messages.
    # Ack must contain either a SIF_Status or a SIF_Error
    #@see Status
    #@see Error
    class Ack < Message
      element :original_source_id, :type => :mandatory
      element :original_msg_id, :type => :mandatory
      element :status, :type => :conditional, :conditions => [:error]
      element :error, :type => :conditional, :conditions => [:status]
      
      def initialize(values = {})
        if values.has_key?(:status) and values[:status].is_a?(Hash)
          values[:status] = Status.new(values[:status])
        end
        if values.has_key?(:error) and values[:error].is_a?(Hash)
          values[:error] = Error.new(values[:error])
        end
        super(values)
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
    
    ERROR_CATEGORY = {
      0	 => "Unknown (This should NEVER be used if possible)",
      1	 => "XML Validation",
      2	 => "Encryption",
      3	 => "Authentication",
      4	 => "Access and Permissions",
      5	 => "Registration",
      6	 => "Provision",
      7	 => "Subscription",
      8	 => "Request and Response",
      9	 => "Event Reporting and Processing",
      10 => "Transport",
      11 => "System (OS, Database, Vendor localized, etc.)",
      12 => "Generic Message Handling",
      13 => "SMB Handling"
    }
    
    XML_VALIDATION_ERROR = {
      1	=> "Generic error",
      2	=> "Message is not well-formed",
      3	=> "Generic validation error",
      4	=> "Invalid value for element/attribute",
      6	=> "Missing mandatory element/attribute"
    }
    
    ENCRYPTION_ERROR = { 1 => "Generic Error" }
    
    AUTHENTICATION_ERROR = {
      1	 => "Generic error",
      2	 => "Generic authentication error (with signature)",
      3	 => "Missing sender's certificate",
      4	 => "Invalid certificate",
      5	 => "Sender's certificate is not trusted",
      6	 => "Expired certificate",
      7	 => "Invalid signature",
      8	 => "Invalid encryption algorithm (only accepts MD4)",
      9	 => "Missing public key of the receiver (when decrypting message)",
      10 => "Missing receiver's private key (when decrypting message)"
    }
    
    ACCESS_AND_PERMISSION_ERROR = {
      1	 => "Generic error",
      2	 => "No permission to register",
      3	 => "No permission to provide this object",
      4	 => "No permission to subscribe to this SIF_Event",
      5	 => "No permission to request this object",
      6	 => "No permission to respond to this object request",
      7	 => "No permission to publish SIF_Event",
      8	 => "No permission to administer policies",
      9	 => "SIF_SourceId is not registered",
      10 => "No permission to publish SIF_Event Add",
      11 => "No permission to publish SIF_Event Change",
      12 => "No permission to publish SIF_Event Delete"
    }
    
    REGISTRATION_ERROR = {
      1	 => "Generic error",
      2	 => "The SIF_SourceId is invalid",
      3	 => "Requested transport protocol is unsupported",
      4	 => "Requested SIF_Version(s) not supported.",
      6	 => "Requested SIF_MaxBufferSize is too small",
      7	 => "ZIS requires a secure transport",
      9	 => "Agent is registered for push mode (returned when a push-mode agent sends a SIF_GetMessage).",
      10 => "ZIS does not support the requested Accept-Encoding value."
    }
    
    PROVISION_ERROR = {
      1	=> "Generic error",
      3	=> "Invalid object",
      4	=> "Object already has a provider (SIF_Provide message)"
    }
    
    SUBSCRIPTION_ERROR = {
      1 => "Generic error",
      3 => "Invalid object"
    }
    
    REQUEST_AND_RESPONSE_ERROR = {
      1	 => "Generic error",
      3	 => "Invalid object",
      4	 => "No provider",
      7	 => "Responder does not support requested SIF_Version",
      8	 => "Responder does not support requested SIF_MaxBufferSize",
      9	 => "Unsupported query in request",
      10 => "Invalid SIF_RequestMsgId specified in SIF_Response",
      11 => "SIF_Response is larger than requested SIF_MaxBufferSize",
      12 => "SIF_PacketNumber is invalid in SIF_Response",
      13 => "SIF_Response does not match any SIF_Version from SIF_Request",
      14 => "SIF_DestinationId does not match SIF_SourceId from SIF_Request",
      15 => "No support for SIF_ExtendedQuery",
      16 => "SIF_RequestMsgId deleted from cache due to timeout",
      17 => "SIF_RequestMsgId deleted from cache by administrator",
      18 => "SIF_Request cancelled by requesting agent"
    }
    
    EVENT_REPORTING_AND_PROCESSING_ERROR = {
      1 => "Generic error",
      3 => "Invalid event"
    }
    
    TRANSPORT_ERROR = {
      1	=> "Generic error",
      2	=> "Requested protocol is not supported",
      3	=> "Secure channel requested and no secure path exists",
      4	=> "Unable to establish connection"
    }
    
    SYSTEM_ERROR = { 1 => "Generic error" }
    
    GENERIC_MESSAGE_HANDLING_ERROR = {
      1	=> "Generic error",
      2	=> "Message not supported",
      3	=> "Version not supported",
      4	=> "Context not supported",
      5	=> "Protocol error",
      6	=> "No such message (as identified by SIF_OriginalMsgId)",
      7	=> "Multiple contexts not supported"
    }
    
    SMB_ERROR = {
      1	=> "Generic error",
      2	=> "SMB can only be invoked during a SIF_Event acknowledgement",
      3	=> "Final SIF_Ack expected from Push-Mode Agent",
      4	=> "Incorrect SIF_MsgId in final SIF_Ack"
    }
  end
end