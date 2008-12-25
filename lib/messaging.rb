module Siffer
  module Messaging
    
    class BadContentType < Exception ; end
    
    def request_failed_messaging?
      begin
        check_content_type_against_messaging
      rescue BadContentType
         @response = Response.new(Siffer::Protocol::HTTP_STATUS_CODES[406],
                        406,
                        {"Content-Type" => Siffer::Messaging::MIME_TYPES["htm"]})
      end
    end
    
    def check_content_type_against_messaging
      unless @request.content_type == MIME_TYPES["appxml"] or 
          @request.content_type == MIME_TYPES["xml"]
        raise BadContentType
      end
    end
    
    # Builds the returnable message from the information in the request
    # Determines if HTTP_SOURCE is provided (Siffer Messaging specific)
    # and defaults to that for the source identifier. If HTTP_SOURCE is 
    # not present then the source identifier is created from the following:
    # HTTP_HOST (if provided)
    # SERVER_NAME
    # SERVER_PORT
    # HTTP_USER_AGENT (if provided and only shown as "Browser")
    def build_message_from_request    
      source = "Generic"
      if @request.env["HTTP_SOURCE"].nil?
        if @request.env["HTTP_HOST"].nil?
          source = "#{@request.env["SERVER_NAME"]}:#{@request.env["SERVER_PORT"]}"
        else
          source = "#{@request.env["HTTP_HOST"]}"
        end
        if @request.env["HTTP_USER_AGENT"]
          source += ":Browser"
        end
      else
        source = @request.env["HTTP_SOURCE"]
      end
      @message = Siffer::Messages::Message.new(source)
    end
    
    MIME_TYPES = {
      "appxml" => "application/xml;charset=utf-8",
      "htm"   => "text/html",
      "html"  => "text/html",
      "xml"   => "text/xml"
    }
    
  end
end