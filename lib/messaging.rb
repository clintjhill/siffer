module Siffer
  # The Messaging module takes care of all of the Message handling for
  # Siffer. It will check messages against content-type constraints as 
  # well as validate the message XML against constraints outlined in the
  # SIF Implementation Specification.
  module Messaging
    
    class BadContentType < Exception #:nodoc:
    end
    class MalformedXml < Exception #:nodoc:
    end
    class MalformedSIFMessage < Exception #:nodoc:
    end
    class XmlNsMismatch < Exception #:nodoc:
    end
    class VersionMismatch < Exception #:nodoc:
    end
    
    # Checks the request against the messaging constraints:
    # * check_content_type
    # * validate_message
    # Raises exceptions accordingly.
    def request_failed_messaging?
      begin
        check_content_type
        validate_message
      rescue BadContentType
        # Make a better Not Acceptable response
         @response = Response.new(Siffer::Protocol::HTTP_STATUS_CODES[406],
                      406,
                      {"Content-Type" => MIME_TYPES["htm"]})
      rescue MalformedXml; error_response(1,2);
      rescue MalformedSIFMessage; error_response(12,2);
      rescue VersionMismatch; error_response(12,3);
      rescue XmlNsMismatch; error_response(1,4,"XMLNS not compatible with SIF")
      end
    end
    
    # Reads request content type and validates it's either text/xml
    # or application/xml;charset=utf-8. If it isn't it will raise a
    # BadContentType exception.
    def check_content_type
      content_type = @request.content_type
      unless [MIME_TYPES["xml"], MIME_TYPES["appxml"]].include? content_type
        raise BadContentType
      end
    end
    
    # Validates the Request Body against the constraints of SIF Messaging.
    # 
    # Currently validates:
    # * <tt>well-formed XML</tt> - XML must be valid and well formed.
    # * <tt>message root</tt> - XML must be a SIF message.
    # * <tt>version</tt> - Must match SIF version implemented. 
    # * <tt>xmlns</tt> - Must match xmlns implemented.
    #
    # Does not validate SIF_Message against different versions of SIF !!!!
    def validate_message
      begin
        xml = REXML::Document.new(@request.body.read)
        # validate Message Root
        raise MalformedSIFMessage unless xml.root.name == "SIF_Message"
        # validate version
        unless xml.root.attributes["version"] == Siffer.sif_version
          raise VersionMismatch 
        end
        # validate xmlns
        unless xml.root.attributes["xmlns"] == Siffer.sif_xmlns
          raise XmlNsMismatch
        end
         # any others?
      rescue REXML::ParseException
        raise MalformedXml
      end
    end
    
    # Sets the @response to a Siffer::Messages::Ack message with the 
    # appropriate Error category and code. Optional description is allowed
    # and placed in the ExtendedDesc node.
    def error_response(category,code, desc = nil)
      error = Siffer::Messages::Error.new(category,code,desc)
      original = Siffer::Messages::RequestBody.parse(@request.body)
      ack = Siffer::Messages::Ack.new(self.name, original, :error => error)
      @response = Response.new(ack)
    end
    
    def no_response_available
      if @response.nil?
        err = "You are receiving this message because you failed to \
        provide enough information to respond to. This is likely due\
        to no message type being provided (i.e. Register,Provide). Please\
        check the message you are sending and resend after any corrections."
        !error_response(12,1,err)
      end
    end
  
    # MIME Types used in Siffer
    MIME_TYPES = {
      "appxml" => "application/xml;charset=utf-8", 
      "htm"   => "text/html",
      "html"  => "text/html",
      "xml"   => "text/xml"
    }
    
  end
end