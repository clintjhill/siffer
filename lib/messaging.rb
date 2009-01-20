module Siffer
  # The Messaging module takes care of all of the Message handling for
  # Siffer. It will check messages against content-type constraints as 
  # well as validate the message XML against constraints outlined in the
  # SIF Implementation Specification.
  module Messaging

    include Siffer::Messages

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
    
    # Provides a context for the original message.
    def using_message_from(request, &block)
      yield if block_given?
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
    # The word "validate" is used loosely as there is no XML validation
    # currently. 
    #
    # Currently validates:
    # * <tt>well-formed XML</tt> - XML must be well formed.
    # * <tt>message root</tt> - XML must be a SIF message.
    # * <tt>version</tt> - Must match SIF version implemented. 
    # * <tt>xmlns</tt> - Must match xmlns implemented.
    #
    # Does not validate:
    # * valid XML
    # * different versions of SIF
    def validate_message
      begin
        body = (@request.body.respond_to? :read) ? @request.body.read : @request.body
        xml = REXML::Document.new(body)
        # validate Message Root
        raise MalformedXml if xml.root.nil?
        # validate Message Root is a SIF_Message
        raise MalformedSIFMessage if xml.root.name != "SIF_Message"
        # validate SIF version
        raise VersionMismatch if xml.root.attributes["version"] != Siffer.sif_version
        # validate SIF xmlns
        raise XmlNsMismatch if xml.root.attributes["xmlns"] != Siffer.sif_xmlns
         # any others?
      rescue REXML::ParseException
        raise MalformedXml
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