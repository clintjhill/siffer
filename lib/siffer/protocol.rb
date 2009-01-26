module Siffer
  # The Protocol module deals with the transport validation. Provides
  # constants for HTTP statuses as well as acceptable paths for Siffer
  # Servers and Agents.
  module Protocol
    
    include Siffer::Messages
    include Siffer::Messaging
    
    class UnknownPath < Exception; end #:nodoc:
    class NonPostRequest < Exception; end #:nodoc:
    
    # Checks the incoming request against the following protocol constraints:
    # * Unknown PATH
    # * Non-POST request
    def request_failed_protocol?
      if @request.get? and @request.path_info == ACCEPTABLE_PATHS[:root]
        root_response
      else
        begin
          check_path_against_protocol
        rescue UnknownPath
          # TODO: Make a better Not Found response
          @response = Response.new(HTTP_STATUS_CODES[404],
                        404,
                        {"Content-Type" => MIME_TYPES["htm"]})
        rescue NonPostRequest
          # TODO: Make a better Method Not Allowed response
          @response = Response.new(HTTP_STATUS_CODES[405],
                        405,
                        {"Content-Type" => MIME_TYPES["htm"]})
        end
      end
    end
    
    # Validates the request object against the Acceptable Paths (Siffer spec)
    # and that the request is a POST.
    def check_path_against_protocol
      unless ACCEPTABLE_PATHS.has_value? @request.path_info
        raise UnknownPath
      end
      unless @request.post?
        raise NonPostRequest
      end
    end
    
    # Returns the URI of the component (Server or Agent)
    def uri
       URI.parse("http://#{host.gsub(/(http|https):\/\//,"")}:#{port}").to_s
    end
    
    # Provides a context for each request. Creates the @request, @response and
    # @original objects to use throughout the call. 
    # Validates against Protocol as well as Messaging using #request_failed 
    # predicates respectively.
    #
    # Yields the block if provided to allow further processing. 
    #
    #Finishes by calling #finish on the response object or returns the generic
    # response message.
    def with_each_request(env, &block)
      @request = Request.new(env)
      unless request_failed_protocol? or request_failed_messaging?
        using_message_from @request do # possibly a concurrency issue here
          yield if block_given?
        end
      end
      @response.finish unless no_response_available
    end

    # Sets the @response to a Siffer::Messages::Ack message with the 
    # appropriate Error category and code. Optional description is allowed
    # and placed in the ExtendedDesc node.
    def error_response(category,code, desc = nil)
      error = Error.new(category,code,desc)
      ack = Ack.new(self.name, @request.original, :error => error)
      @response = Response.new(ack)
    end

    # Determines if there is a response instance created. If not
    # it creates one with an Ack/Error describing not having 
    # anything to process.
    def no_response_available
      if @response.nil?
        err = <<"ERR"
You are receiving this message because you failed to 
provide enough information to respond to. This message 
went completely through the messaging stack and
failed to instigate a response.
 
Please check the message you are sending and resend after 
any corrections.
ERR
        !error_response(12,1,err)
      end
    end
    
    def root_response
      html = <<"HTML"
<html>
  <body>
    <h1>Siffer Endpoint</h1>
    <p>You have reached a Siffer component.</p>
  </body>
</html>
HTML
      @response = Response.new(html,200,{"Content-Type" => MIME_TYPES["htm"]})
    end
        
    # Paths that comply with the messaging protocol determined
    # by the SIF Specification. These are Siffer specific and not
    # spelled out in SIF Specification (rather implied). 
    ACCEPTABLE_PATHS = {
      :root => "/",
      :ping => "/ping",
      :status => "/status",
      :register => "/register"
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