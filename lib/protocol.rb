module Siffer
  module Protocol
    
    class UnknownPath < Exception; end
    class NonPostRequest < Exception; end
    
    def request_failed_protocol?
      begin
        check_path_against_protocol
      rescue UnknownPath
        # Do I want this to be a better 404 html response?
        @response = Response.new(HTTP_STATUS_CODES[404],
                      404,
                      {"Content-Type" => Siffer::Messaging::MIME_TYPES["htm"]})
      rescue NonPostRequest
        @response = Response.new(HTTP_STATUS_CODES[405],
                      405,
                      {"Content-Type" => Siffer::Messaging::MIME_TYPES["htm"]})
      end
    end
    
    # Validates the request object against 
    # the Acceptable Paths (Siffer spec) and that
    # the request is a POST.
    def check_path_against_protocol
      unless ACCEPTABLE_PATHS.values.include? @request.path_info
        raise UnknownPath
      end
      unless @request.post? 
        raise NonPostRequest
      end
    end
    
    # Returns the URI of the component
    def uri
       URI.parse("http://#{host}:#{port}").to_s
    end
    
    # Paths that comply with the messaging protocol determined
    # by the SIF Specification.
    ACCEPTABLE_PATHS = {
      :root => "/",
      :ping => "/ping",
      :status => "/status"
    }
    
    # Every standard HTTP code mapped to the appropriate message.
    # Stolen from Mongrel.
    HTTP_STATUS_CODES = {
      100  => 'Continue',
      101  => 'Switching Protocols',
      200  => 'OK',
      201  => 'Created',
      202  => 'Accepted',
      203  => 'Non-Authoritative Information',
      204  => 'No Content',
      205  => 'Reset Content',
      206  => 'Partial Content',
      300  => 'Multiple Choices',
      301  => 'Moved Permanently',
      302  => 'Moved Temporarily',
      303  => 'See Other',
      304  => 'Not Modified',
      305  => 'Use Proxy',
      400  => 'Bad Request',
      401  => 'Unauthorized',
      402  => 'Payment Required',
      403  => 'Forbidden',
      404  => 'Not Found',
      405  => 'Method Not Allowed',
      406  => 'Not Acceptable',
      407  => 'Proxy Authentication Required',
      408  => 'Request Time-out',
      409  => 'Conflict',
      410  => 'Gone',
      411  => 'Length Required',
      412  => 'Precondition Failed',
      413  => 'Request Entity Too Large',
      414  => 'Request-URI Too Large',
      415  => 'Unsupported Media Type',
      500  => 'Internal Server Error',
      501  => 'Not Implemented',
      502  => 'Bad Gateway',
      503  => 'Service Unavailable',
      504  => 'Gateway Time-out',
      505  => 'HTTP Version not supported'
    }
  
  end
end