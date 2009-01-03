module Siffer

  # Zone Integration Server
  # Facilitates communication between Agents. Acts as a central point
  # where Agents can send their events/requests and receive the response
  # from other Agents. 
  class Server
    include Siffer::Protocol
    include Siffer::Messaging
    
    attr_reader :name, :host, :port, :agents
    
    ## options Parameter
    # name = The name of the ZIS
    # host = The host this instance is started on
    # port = The port to connect to this ZIS
    # admin = The administration site managing this ZIS
    def initialize(options = {})
      raise "Administration URL required" unless options.include? "admin"

      @name = options["name"] || "Default Server"
      @host = options["host"] || "localhost"
      @port = options["port"] || 8300
      @agents = {}

    end
    
    # Will validate the request against the Siffer::Protocol and 
    # Siffer::Messaging constraints. Process responses based on
    # requests path or content determined by the predicate methods
    # implemented in Siffer::Protocol::ACCEPTABLE_PATHS
    def call(env)
      @request = Request.new(env)
      unless request_failed_protocol? or request_failed_messaging?
        # Perform response based on SIF_Message type       
      end
      @response.finish unless no_response_available
    end
          
  end

end