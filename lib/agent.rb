module Siffer
  
  class Agent
    include Siffer::Protocol
    include Siffer::Messaging
    
    attr_reader :name, :host, :port
    
    def initialize(options = {})
      raise "Server URL(s) required" unless options.include? "servers"
      @name = options["name"] || "Default Agent"
      @host = options["host"] || "localhost"
      @port = options["port"] || 8300
    end
    
    def call(env)
      @request = Request.new(env)
      unless request_failed_protocol? or request_failed_messaging?
        build_message_from_request
        @response = Response.new(Siffer::Messages::Ack.new(self.name,@message))
      end
      @response.finish
    end
   
  end
  
end