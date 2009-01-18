module Siffer

  # Zone Integration Server
  # Facilitates communication between Agents. Acts as a central point
  # where Agents can send their events/requests and receive the response
  # from other Agents. 
  class Server
    include Siffer::Protocol
    include Siffer::Registration
    
    attr_reader :name, :host, :port, :min_buffer, :agents
    
    ## options Parameter
    # name = The name of the ZIS
    # host = The host this instance is started on
    # port = The port to connect to this ZIS
    # admin = The administration site managing this ZIS
    # min_buffer = The minimum buffer size this ZIS will facilitate
    def initialize(options = {})
      raise ArgumentError, "Administration URL required" unless options.include? "admin"
      @name = options["name"] || "Default Server"
      @host = options["host"] || "localhost"
      @port = options["port"] || 8300
      @min_buffer = options["min_buffer"] || 1024
      @agents = {}
    end
    
    # Process the request with all the SIF protocols
    def call(env)
      with_each_request(env) do
         process_registration
          # process_provision
          # process_subscription
          # process_event
      end
    end
          
  end

end