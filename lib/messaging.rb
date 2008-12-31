module Siffer
  module Messaging
    
    class BadContentType < Exception ; end
    
    # Checks the request against the messaging constraints
    def request_failed_messaging?
      begin
        check_content_type
      rescue BadContentType
         @response = Response.new(Siffer::Protocol::HTTP_STATUS_CODES[406],
                      406,
                      {"Content-Type" => MIME_TYPES["htm"]})
      end
    end
    
    # Reads request content type and validates it's acceptable or not
    def check_content_type
      unless @request.content_type == MIME_TYPES["appxml"] or 
          @request.content_type == MIME_TYPES["xml"]
        raise BadContentType
      end
    end
    
    # Builds the returnable message from the information in the request
    def build_message_from_request    
      source = "#{@request.env["SERVER_NAME"]}:#{@request.env["SERVER_PORT"]}"
      @message = Siffer::Messages::Message.new(source)
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