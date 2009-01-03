module Siffer
  
  class Agent
    include Siffer::Protocol
    include Siffer::Messaging
    
    attr_reader :name, :host, :port, :admin, :server
    
    def initialize(options = {})
      raise "Server URL(s) required" unless options.include? "servers"
      @server = options["servers"]
      raise "Administration URL required" unless options.include? "admin"
      @admin = options["admin"]
      @name = options["name"] || "Default Agent"
      @host = options["host"] || "localhost"
      @port = options["port"] || 8300
      @registered = false
    end
    
    def call(env)
      @request = Request.new(env)
      unless request_failed_protocol? or request_failed_messaging?
        # Perform response based on SIF_Message type
      end
      @response.finish unless no_response_available
    end

    def wake_up
      register unless registered? 
    end
    
    def register
        registration = Siffer::Messages::Register.new(name, name)
        response = Response.from(server,registration) 
        @registered = response.ok?
    end
    
    def registered?
      @registered
    end
    
  end
  
end