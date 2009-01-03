module Siffer
  module Messages
    class Error
      
      attr_reader :category, :code, :description
      
      def initialize(category, code, desc = nil)
        @category = CATEGORY[category]
        @category_index = category
        @code = CODE[@category][code]
        @code_index = code
        @description = desc
      end
      
      def read
        xml = Builder::XmlMarkup.new
        xml.SIF_Error { |error|
          error.SIF_Category(@category_index)
          error.SIF_Code(@code_index)
          error.SIF_Desc(@code)
          error.SIF_ExtendedDesc(@description) unless @description.nil?
        }
      end
      
      def to_str
        read
      end
      
      # Categories of Errors specified by SIF
      CATEGORY = [
        "Unknown (This should NEVER be used if possible)",
        "XML Validation",
        "Encryption",
        "Authentication",
        "Access and Permissions",
        "Registration",
        "Provision",
        "Subscription",
        "Request and Response",
        "Event Reporting and Processing",
        "Transport",
        "System (OS, Database, Vendor localized, etc.)",
        "Generic Message Handling",
        "SMB Handling"
      ]
      
      # Codes related to CATEGORY
      # Some codes are blank to match the SIF Spec
      CODE = {
        CATEGORY[1] => [ # Xml Validation
          "",
          "Generic error",
          "Message is not well-formed",
          "Generic validation error",
          "Invalid value for element/attribute",
          "",
          "Missing mandatory element/attribute"
          ],
        CATEGORY[2] => [ # Encryption
          "",
          "Generic error"
          ],
        CATEGORY[3] => [ # Authentication
          "",
          "Generic error",
          "Generic authentication error (with signature)",
          "Missing sender's certificate",
          "Invalid certificate",
          "Sender's certificate is not trusted",
          "Expired certificate",
          "Invalid signature",
          "Invalid encryption algorithm (only accepts MD4)",
          "Missing public key of the receiver (when decrypting message)", 
          "Missing receiver's private key (when decrypting message)"
          ],
        CATEGORY[4] => [ # Access and Permissions
          "",
          "Generic error",
          "No permission to register",
          "No permission to provide this object",
          "No permission to subscribe to this SIF_Event",
          "No permission to request this object",
          "No permission to respond to this object request", 
          "No permission to publish SIF_Event",
          "No permission to administer policies",
          "SIF_SourceId is not registered",
          "No permission to publish SIF_Event Add",
          "No permission to publish SIF_Event Change",
          "No permission to publish SIF_Event Delete"
          ],
        CATEGORY[5] => [ # Registration
          "",
          "Generic error",
          "The SIF_SourceId is invalid",
          "Requested transport protocol is unsupported", 
          "Requested SIF_Version(s) not supported",
          "",
          "Requested SIF_MaxBufferSize is too small", 
          "ZIS requires a secure transport",
          "",
          "Agent is registered for push mode (returned when a push-mode agent sends a SIF_GetMessage)", 
          "ZIS does not support the requested Accept-Encoding value"    
          ],
        CATEGORY[6] => [ # Provision
          "",
          "Generic error",
          "",
          "Invalid object", 
          "Object already has a provider (SIF_Provide message)"
          ],
        CATEGORY[7] => [ # Subscription
          "",
          "Generic error",
          "",
          "Invalid object"
          ],
        CATEGORY[8] => [ # Request and Response
          "",
          "Generic error",
          "",
          "Invalid object",
          "No provider",
          "",
          "",
          "Responder does not support requested SIF_Version",
          "Responder does not support requested SIF_MaxBufferSize",
          "Unsupported query in request",
          "Invalid SIF_RequestMsgId specified in SIF_Response",
          "SIF_Response is larger than requested SIF_MaxBufferSize",
          "SIF_PacketNumber is invalid in SIF_Response",
          "SIF_Response does not match any SIF_Version from SIF_Request",
          "SIF_DestinationId does not match SIF_SourceId from SIF_Request", 
          "No support for SIF_ExtendedQuery",
          "SIF_RequestMsgId deleted from cache due to timeout",
          "SIF_RequestMsgId deleted from cache by administrator",
          "SIF_Request cancelled by requesting agent"
          ],
        CATEGORY[9] => [ # Event Reporting and Processing
          "",
          "Generic error",
          "", 
          "Invalid event"
          ],
        CATEGORY[10] => [ # Transport
          "",
          "Generic error",
          "Requested protocol is not supported",
          "Secure channel requested and no secure path exists", 
          "Unable to establish connection"
          ],
        CATEGORY[11] => [ # System
          "",
          "Generic Error"
          ],
        CATEGORY[12] => [ # Generic Message Handling
          "",
          "Generic error",
          "Message not supported",
          "Version not supported",
          "Context not supported",
          "Protocol error",
          "No such message (as identified by SIF_OriginalMsgId)", 
          "Multiple contexts not supported"
          ],
        CATEGORY[13] => [ # SMB Handling
          "",
          "Generic error",
          "SMB can only be invoked during a SIF_Event acknowledgement", 
          "Final SIF_Ack expected from Push-Mode Agent",
          "Incorrect SIF_MsgId in final SIF_Ack"
          ]
      }
      
    end
  end
end