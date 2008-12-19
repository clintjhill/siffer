module Siffer

  class Server
    include Siffer::Protocol
    include Siffer::Messaging
    
    attr_reader :name, :host, :port
    
    def initialize(options = {})
        @name = options[:name] || "Default Server"
        @host = options[:host] || "localhost"
        @port = options[:port] || 8300
    end
    
    def call(env)
      @request = Request.new(env)
      check_content_type_against_messaging
      check_path_against_protocol
      build_message_from_request
  
      @response = Response.new(Siffer::Messages::Ack.new(self.name,@message))
      @response["Content-Type"] = MIME_TYPES["appxml"] 
      
      if @request.ping?
        # Do something to the response to add data to the Ack
      end
      
      @response.finish
    end
          
  end

end