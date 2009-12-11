module Siffer
  module Messages

    class Error < AcDc::Body
      tag_name "SIF_Error"
      element :category, Integer, :tag => "SIF_Category"
      element :code, Integer, :tag => "SIF_Code"
      element :description, String, :tag => "SIF_Desc"
      element :extended_description, String, :tag => "SIF_Extended_Desc"
      
      def self.create(options = {}, &block)
        error = Error.new
        error.category = options[:error_category]
        error.code = options[:error_code]
        error.description = options[:error_desc]
        yield error if block_given?
        raise "Error Category is required" if error.category.nil?
        raise "Error Code is required" if error.code.nil?
        raise "Error Description is required" if error.description.nil?
        raise "Error Category is invalid" unless ERROR_CATEGORY.keys.include?(error.category)
        raise "Error Code is invalid" unless ERROR_CODES[error.category].detect{|codes| codes[0] == error.code}
        error
      end
    end
        
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
    
    ERROR_CODES = {
      1 => XML_VALIDATION_ERROR, 
      2 => ENCRYPTION_ERROR, 
      3 => AUTHENTICATION_ERROR, 
      4 => ACCESS_AND_PERMISSION_ERROR,
      5 => REGISTRATION_ERROR,
      6 => PROVISION_ERROR,
      7 => SUBSCRIPTION_ERROR,
      8 => REQUEST_AND_RESPONSE_ERROR,
      9 => EVENT_REPORTING_AND_PROCESSING_ERROR,
      10 => TRANSPORT_ERROR,
      11 => SYSTEM_ERROR,
      12 => GENERIC_MESSAGE_HANDLING_ERROR,
      13 => SMB_ERROR}
      
  end
end