module Siffer
  
  class Agent
    
    include Siffer::Protocol
    
    attr_reader :name, :host, :port, :admin, :server
    
    def initialize(options = {})
      raise "Zone Integration Server URL required" unless options.include? "server"
      @server = options["server"]
      raise "Administration URL required" unless options.include? "admin"
      @admin = options["admin"]
      @name = options["name"] || "Default Agent"
      @host = options["host"] || "localhost"
      @port = options["port"] || 8300
      @registered = false
    end
    
    def call(env)
      with_each_request(env) do
        #process_event
        #process_request
        #process_response
      end
    end

    def wake_up
      self_register unless registered? 
    end
    
    def self_register
      registration = Siffer::Messages::Register.new(name, name)
      response = Response.from(server,registration) 
      # OOOOH BAAAAD ====> Check the ACL please ! Make a parser !
      @registered = response.ok?
    end
    
    def registered?
      @registered
    end
    
  end
  
end